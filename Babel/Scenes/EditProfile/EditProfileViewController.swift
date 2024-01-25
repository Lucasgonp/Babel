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
    enum Texts {
        static let title = Strings.Settings.EditProfile.title.localized()
        static let namePlaceholder = Strings.Settings.EditProfile.namePlaceholder.localized()
        static let done = Strings.Commons.done.localized()
    }
}

final class EditProfileViewController: ViewController<EditProfileInteractorProtocol, UIView> {
    fileprivate enum Layout { }
    
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
            placeholder: Layout.Texts.namePlaceholder,
            hint: Layout.Texts.namePlaceholder,
            isHintAlwaysVisible: true,
            autocapitalizationType: .words,
            textLength: 32
        ))
        textField.returnKeyType = .done
        textField.enablesReturnKeyAutomatically = true
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var currentUser: User {
        UserSafe.shared.user
    }
    
    private var headerCell: EditProfileHeaderCell?
    private var shouldUpdateInto = false
    
    private var galleryController: GalleryController?
    
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
        view.fillWithSubview(subview: tableView)
    }
    
    override func setupConstraints() { 
        // template
    }

    override func configureViews() { 
        title = Layout.Texts.title
        view.backgroundColor = Color.backgroundPrimary.uiColor
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
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            interactor.didTapChangeBio()
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
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell: EditProfileHeaderCell = tableView.makeCell(indexPath: indexPath, selectionStyle: .none)
                cell.render(currentUser)
                cell.delegate = self
                headerCell = cell
                return cell
            } else {
                let cell: UITableViewCell = tableView.makeCell(indexPath: indexPath, selectionStyle: .none)
                fullNameTextField.text = currentUser.name
                cell.contentView.fillWithSubview(subview: fullNameTextField, spacing: .init(top: 12, left: 4, bottom: 2, right: 4))
                return cell
            }
        case 1:
            let cell: UITableViewCell = tableView.makeCell(indexPath: indexPath, accessoryType: .disclosureIndicator)
            var content = cell.defaultContentConfiguration()
            content.text = currentUser.status
            cell.contentConfiguration = content
            return cell
        default:
            return UITableViewCell()
        }
    }
}

private extension EditProfileViewController {    
    func configureNavigation() {
        let done = UIBarButtonItem(title: Layout.Texts.done, style: .done, target: self, action: #selector(didTapDoneButton))
        navigationItem.setRightBarButton(done, animated: true)
        updateDoneBarButton(isHidden: true)
    }
    
    func updateDoneBarButton(isEnabled: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isEnabled
    }
    
    func updateDoneBarButton(isHidden: Bool) {
        // TODO: Check if is hiding correctly
        if isHidden {
            navigationItem.rightBarButtonItem = nil
        } else {
            let done = UIBarButtonItem(title: Layout.Texts.done, style: .done, target: self, action: #selector(didTapDoneButton))
            navigationItem.rightBarButtonItem = done
        }
    }
}

@objc private extension EditProfileViewController {
    func didTapDoneButton() {
        view.endEditing(true)
        var currentUser = currentUser
        currentUser.name = fullNameTextField.text
        interactor.saveUserToFirebase(user: currentUser)
    }
}

extension EditProfileViewController: EditProfileHeaderDelegate {    
    func didTapOnEditAvatar() {
        fullNameTextField.text = currentUser.name
        galleryController = GalleryController()
        galleryController?.configuration = .avatarPhoto
        galleryController?.showSinglePhotoPicker(from: navigationController) { [weak self] image in
            self?.galleryController = nil
            if let image {
                self?.headerCell?.update(image)
                self?.interactor.updateAvatarImage(image)
            }
        }
    }
    
    func didTapOnAvatar(image: UIImage) {
        let previewImageView = PreviewAvatarViewController(image: image)
        previewImageView.modalTransitionStyle = .crossDissolve
        previewImageView.modalPresentationStyle = .overFullScreen
        present(previewImageView, animated: true)
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
