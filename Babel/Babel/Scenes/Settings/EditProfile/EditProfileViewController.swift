import UIKit
import DesignKit
import GalleryKit

protocol EditProfileDisplaying: AnyObject {
    func displayEditProfile()
    func updateEditProfile()
    func updateAvatarImage(_ image: UIImage)
    func displayErrorMessage(message: String)
}

private extension EditProfileViewController.Layout {
    // example
    enum Size {
        static let imageHeight: CGFloat = 90.0
    }
}

final class EditProfileViewController: ViewController<EditProfileInteracting, UIView> {
    fileprivate enum Layout { }
    typealias Localizable = Strings.Settings.EditProfile
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(cellType: EditProfileHeaderCell.self)
        tableView.register(cellType: UITableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    private lazy var fullNameTextField: TextField = {
        let textField = TextField()
        textField.render(.clean(
            placeholder: Localizable.namePlaceholder,
            hint: Localizable.namePlaceholder,
            isHintAlwaysVisible: true,
            autocapitalizationType: .words
        ))
        textField.returnKeyType = .done
        textField.enablesReturnKeyAutomatically = true
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var headerCell: EditProfileHeaderCell?
    private var shouldUpdateInto = false
    private var currentUser: User? {
        AccountInfo.shared.user
    }
    
    private lazy var galleryController = GalleryController(configuration: .avatarPhoto)
    
    weak var delegate: SettingsViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode =  .never
        if shouldUpdateInto {
            interactor.getUpdatedUser()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        shouldUpdateInto = true
    }

    override func buildViewHierarchy() { 
        view.fillWithSubview(subview: tableView, navigationSafeArea: true)
    }
    
    override func setupConstraints() { 
        // template
    }

    override func configureViews() { 
        title = Localizable.title
        view.backgroundColor = Color.grayscale050.uiColor
        configureNavigation()
    }
}

// MARK: - EditProfileDisplaying
extension EditProfileViewController: EditProfileDisplaying {
    func displayEditProfile() {
        tableView.reloadData()
    }
    
    func updateEditProfile() {
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
    }
    
    func updateAvatarImage(_ image: UIImage) {
        delegate?.updateAvatar(image: image)
    }
    
    func displayErrorMessage(message: String) {
        showErrorAlert(message)
    }
}

extension EditProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let viewController = UIViewController()
            viewController.title = "Status"
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension EditProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        default:
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentUser else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                guard let cell: EditProfileHeaderCell = makeCell(tableView: tableView, indexPath: indexPath) else {
                    return UITableViewCell()
                }
                cell.render(currentUser)
                cell.delegate = self
                headerCell = cell
                return cell
            } else {
                guard let cell: UITableViewCell = makeCell(tableView: tableView, indexPath: indexPath) else {
                    return UITableViewCell()
                }
                fullNameTextField.text = currentUser.name
                cell.contentView.fillWithSubview(subview: fullNameTextField, spacing: .init(top: 12, left: 4, bottom: 2, right: 4))
                return cell
            }
        case 1:
            guard let cell: UITableViewCell = makeCell(tableView: tableView, indexPath: indexPath, accessoryType: .disclosureIndicator) else {
                return UITableViewCell()
            }
            cell.textLabel?.text = currentUser.status
            return cell
        default:
            return UITableViewCell()
        }
    }
}

private extension EditProfileViewController {
    func makeCell<T: UITableViewCell>(tableView: UITableView, indexPath: IndexPath, accessoryType: UITableViewCell.AccessoryType = .none) -> T? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            return nil
        }
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = .zero
        cell.layoutMargins = .zero
        cell.selectionStyle = .none
        cell.accessoryType = accessoryType
        return cell
    }
    
    func configureNavigation() {
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDoneButton))
        navigationItem.setRightBarButton(done, animated: true)
        updateDoneBarButton(isHidden: true)
    }
    
    func updateDoneBarButton(isEnabled: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isEnabled
    }
    
    func updateDoneBarButton(isHidden: Bool) {
        navigationItem.rightBarButtonItem?.isHidden = isHidden
    }
}

@objc private extension EditProfileViewController {
    func didTapDoneButton() {
        view.endEditing(true)
        
        guard var currentUser else {
            return
        }
        currentUser.name = fullNameTextField.text
        interactor.saveUserToFirebase(user: currentUser)
    }
}

extension EditProfileViewController: EditProfileHeaderDelegate {    
    func didTapOnEditAvatar() {
        galleryController.showSinglePhotoPicker(from: navigationController) { [weak self] image in
            if let image {
                self?.headerCell?.update(image)
                self?.interactor.updateAvatarImage(image)
            }
        }
    }
}

extension EditProfileViewController: TextFieldDelegate {
    func textFieldDidEndEditing(_ textField: TextFieldInput) {
        updateDoneBarButton(isHidden: true)
    }
    
    func textFieldDidBeginEditing(_ textField: TextFieldInput) {
        updateDoneBarButton(isHidden: false)
    }
    
    func textFieldDidChange(_ textField: TextFieldInput) {
        updateDoneBarButton(isEnabled: !fullNameTextField.text.isEmpty)
    }
    
    func textFieldShouldReturn(_ textField: TextFieldInput) {
        didTapDoneButton()
    }
}
