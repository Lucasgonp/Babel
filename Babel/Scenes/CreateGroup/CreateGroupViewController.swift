import UIKit
import DesignKit
import GalleryKit

struct UserInfo2 {
    let name: String
    let description: String
    let avatarLink: String
}

protocol CreateGroupDisplaying: AnyObject {
    func displayAllUsers(_ users: [User])
//    func displayEditProfile()
//    func updateEditProfile()
//    func updateAvatarImage(_ image: UIImage)
//    func displayErrorMessage(message: String)
}

final class CreateGroupViewController: ViewController<CreateGroupInteracting, UIView> {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(cellType: CreateGroupHeaderCell.self)
        tableView.register(cellType: UITableViewCell.self)
        tableView.register(cellType: UserCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    private lazy var fullNameTextField: TextField = {
        let textField = TextField()
        textField.render(.clean(
            placeholder: "Group name",
            hint: "Group name",
            isHintAlwaysVisible: true,
            autocapitalizationType: .words
        ))
        textField.returnKeyType = .done
        textField.enablesReturnKeyAutomatically = true
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var galleryController: GalleryController = {
        let gallery = GalleryController()
        gallery.configuration = .avatarPhoto
        return gallery
    }()
    
    private var currentUser = UserSafe.shared.user
    private var headerCell: CreateGroupHeaderCell?
    
    private var allUsers = [User]()
    private var selectedUsers = [User]()
    
    private var groupName = String()
    private var groupDescription = String()
    
    weak var delegate: SettingsViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.loadAllUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode =  .never
    }
    
    override func buildViewHierarchy() {
        
    }
    
    override func setupConstraints() {
        // template
    }
    
    override func configureViews() {
        title = "Create new group"
        view.backgroundColor = Color.backgroundPrimary.uiColor
        configureNavigation()
    }
}

extension CreateGroupViewController: CreateGroupDisplaying {
    func displayAllUsers(_ users: [User]) {
        allUsers = users
        view.fillWithSubview(subview: tableView)
        tableView.reloadData()
    }
    
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

extension CreateGroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 2:
            let user = allUsers[indexPath.row]
            let cell = tableView.cellForRow(at: indexPath) as? UserCell
            
            if selectedUsers.contains(user) {
                cell?.accessoryType = .none
            } else {
                selectedUsers.append(user)
                cell?.accessoryType = .checkmark
            }
            
            cell?.accessoryType = .checkmark
        default:
            return
        }
    }
}

extension CreateGroupViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return allUsers.count
        default:
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Description"
        case 2:
            return "All users"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell: CreateGroupHeaderCell = tableView.makeCell(indexPath: indexPath, selectionStyle: .none)
                cell.delegate = self
                headerCell = cell
                return cell
            } else if indexPath.row == 1 {
                let cell: UITableViewCell = tableView.makeCell(indexPath: indexPath, selectionStyle: .none)
                cell.contentView.fillWithSubview(subview: fullNameTextField, spacing: .init(top: 8, left: 4, bottom: 2, right: 4))
                return cell
            }
            let celula = UITableViewCell()
            celula.backgroundColor = .red
            return celula
        case 1:
            let cell: UITableViewCell = tableView.makeCell(indexPath: indexPath, accessoryType: .disclosureIndicator)
            var content = cell.defaultContentConfiguration()
            content.text = groupDescription.isEmpty ? "Add group description" : groupDescription
            content.textProperties.color = groupDescription.isEmpty ? Color.blueNative.uiColor : cell.defaultContentConfiguration().textProperties.color
            cell.contentConfiguration = content
            return cell
        case 2:
            let cell: UserCell = tableView.makeCell(indexPath: indexPath, accessoryType: .none)
            let contact = allUsers[indexPath.row]
            cell.render(contact)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

private extension CreateGroupViewController {
    func configureNavigation() {
        let done = UIBarButtonItem(title: Strings.Commons.done, style: .done, target: self, action: #selector(didTapDoneButton))
        navigationItem.setRightBarButton(done, animated: true)
        updateDoneBarButton(isHidden: true)
    }
    
    func updateDoneBarButton(isEnabled: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isEnabled
    }
    
    func updateDoneBarButton(isHidden: Bool) {
        if isHidden {
            navigationItem.rightBarButtonItem = nil
        } else {
            let done = UIBarButtonItem(title: Strings.Commons.done, style: .done, target: self, action: #selector(didTapDoneButton))
            navigationItem.rightBarButtonItem = done
        }
    }
}

@objc private extension CreateGroupViewController {
    func didTapDoneButton() {
        view.endEditing(true)
    }
}

extension CreateGroupViewController: EditProfileHeaderDelegate {
    func didTapOnEditAvatar() {
        galleryController.showSinglePhotoPicker(from: navigationController) { [weak self] image in
            if let image {
                self?.headerCell?.update(image)
//                self?.interactor.updateAvatarImage(image)
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

extension CreateGroupViewController: TextFieldDelegate {
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
