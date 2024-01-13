import UIKit
import DesignKit
import GalleryKit

protocol CreateGroupDisplaying: AnyObject {
    func setLoading(isLoading: Bool)
    func displayAllUsers(_ users: [User])
    func displayErrorMessage(message: String)
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
    
    private lazy var groupNameTextField: TextField = {
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
    
    private lazy var groupDescNavigation: UINavigationController = {
        let controller = EditGroupDescViewController(description: groupDescription)
        let navigation = UINavigationController(rootViewController: controller)
        controller.completion = { [weak self] description in
            self?.groupDescription = description
            self?.tableView.reloadSections(IndexSet(integer: 1), with: .none)
        }
        return navigation
    }()
    
    private var currentUser = UserSafe.shared.user
    private var headerCell: CreateGroupHeaderCell?
    
    private var allUsers = [User]()
    private var selectedUsers = [User]()
    
    private var groupAvatar = Image.avatarPlaceholder.image
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        configureNavigation()
    }
}

extension CreateGroupViewController: CreateGroupDisplaying {
    func displayAllUsers(_ users: [User]) {
        allUsers = users
        view.fillWithSubview(subview: tableView)
        tableView.reloadData()
    }
    
    func setLoading(isLoading: Bool) {
        if isLoading {
            showLoading()
        } else {
            hideLoading()
        }
    }
    
    func displayErrorMessage(message: String) {
        showErrorAlert(message)
    }
}

extension CreateGroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 1:
            present(groupDescNavigation, animated: true)
        case 2:
            let user = allUsers[indexPath.row]
            
            if selectedUsers.contains(user) {
                selectedUsers.removeAll(where: { $0 == user })
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
            } else {
                selectedUsers.append(user)
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
            
            checkCreateButtonState()
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
            } else {
                let cell: UITableViewCell = tableView.makeCell(indexPath: indexPath, selectionStyle: .none)
                cell.contentView.fillWithSubview(subview: groupNameTextField, spacing: .init(top: 8, left: 4, bottom: 2, right: 4))
                return cell
            }
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
        let done = UIBarButtonItem(title: Strings.CreateGroup.createButton, style: .done, target: self, action: #selector(didTapDoneButton))
        done.isEnabled = false
        navigationItem.setRightBarButton(done, animated: false)
    }
    
    func checkCreateButtonState() {
        navigationItem.rightBarButtonItem?.isEnabled = !groupNameTextField.text.isEmpty && selectedUsers.count > 0
    }
}

@objc private extension CreateGroupViewController {
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func didTapDoneButton() {
        view.endEditing(true)
        var selectedUsers = selectedUsers.compactMap({ $0.id })
        
        guard selectedUsers.count > 0 else { return }
        
        selectedUsers.append(currentUser.id)
        let group = CreateGroupDTO(
            name: groupNameTextField.text,
            description: groupDescription,
            memberIds: selectedUsers,
            avatarImage: groupAvatar
        )
        interactor.createGroup(group)
    }
}

extension CreateGroupViewController: EditProfileHeaderDelegate {
    func didTapOnEditAvatar() {
        galleryController.showSinglePhotoPicker(from: navigationController) { [weak self] image in
            if let image {
                self?.groupAvatar = image
                self?.headerCell?.update(image)
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
    func textFieldDidChange(_ textField: TextFieldInput) {
        checkCreateButtonState()
    }
    
    func textFieldShouldReturn(_ textField: TextFieldInput) {
        view.endEditing(true)
    }
}
