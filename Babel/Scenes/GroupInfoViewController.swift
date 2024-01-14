import UIKit
import DesignKit
import GalleryKit

protocol GroupInfoDisplaying: AnyObject {
    func displayViewState(_ state: GroupInfoViewState)
}

enum GroupInfoViewState {
    case success(groupInfo: Group, members: [User])
    case updateInfo(_ dto: EditGroupDTO)
    case updateDesc(_ description: String)
    case error(message: String)
    case setLoading(isLoading: Bool)
}

final class GroupInfoViewController: ViewController<GroupInfoInteracting, UIView> {
    fileprivate enum Layout { }
    typealias Localizable = Strings.GroupInfo
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(cellType: GroupInfoHeaderCell.self)
        tableView.register(cellType: UITableViewCell.self)
        tableView.register(cellType: SettingsButtonCell.self)
        tableView.register(cellType: UserCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    private lazy var editGroupNavigation: UINavigationController = {
        let editGroupController = EditGroupViewController(name: groupInfo?.name, imageLink: groupInfo?.avatarLink)
        editGroupController.completion = { [weak self] dto in
            self?.interactor.updateGroupInfo(dto: dto)
        }
        let navigation = UINavigationController(rootViewController: editGroupController)
        return navigation
    }()
    
    private lazy var groupDescNavigation: UINavigationController = {
        let controller = EditGroupDescViewController(description: groupDescription)
        let navigation = UINavigationController(rootViewController: controller)
        controller.completion = { [weak self] description in
            self?.interactor.updateGroupDesc(description)
        }
        return navigation
    }()
    
    private lazy var addMemberNavigation: UINavigationController = {
        let controller = AddMembersFactory.make(groupMembers: members) { [weak self] users in
            self?.interactor.addMembers(users)
        }
        let navigation = UINavigationController(rootViewController: controller)
        return navigation
    }()
    
    private var groupDescription = String()
    
    private var headerCell: GroupInfoHeaderCell?
    private var currentUser: User { UserSafe.shared.user }
    private var isAdmin: Bool {
        groupInfo?.adminIds.contains(currentUser.id) == true
    }
    
    private var groupInfo: Group?
    private lazy var members = [User]()
    
    weak var delegate: SettingsViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.fetchGroupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }

    override func buildViewHierarchy() {
        view.fillWithSubview(subview: tableView)
    }
    
    override func setupConstraints() {
        // template
    }

    override func configureViews() {
        let backButton = UIBarButtonItem(title: String(), style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        title = Localizable.title
        view.backgroundColor = Color.backgroundPrimary.uiColor
    }
}

extension GroupInfoViewController: GroupInfoDisplaying {
    func displayViewState(_ state: GroupInfoViewState) {
        switch state {
        case let .success(groupInfo, members):
            self.groupInfo = groupInfo
            self.groupDescription = groupInfo.description
            
            self.members = members
                .sorted { $0.name.lowercased() < $1.name.lowercased() }
                .sorted { isUserAdmin($0) && !isUserAdmin($1) }
            
            if groupInfo.adminIds.contains(currentUser.id) {
                configureEditButton()
            }
            
            tableView.reloadData()
            
        case let .updateInfo(dto):
            let dto = EditGroupDTO(name: dto.name, image: dto.image)
            headerCell?.update(dto)
            
        case let .updateDesc(description):
            groupDescription = description
            tableView.reloadSections(IndexSet(integer: 1), with: .none)
            
        case let .error(message):
            showErrorAlert(message)
            
        case let .setLoading(isLoading):
            if isLoading {
                showLoading()
            } else {
                hideLoading()
            }
        }
    }
}

extension GroupInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 1:
            present(groupDescNavigation, animated: true)
        case 3:
            if isAdmin {
                if indexPath.row == 0 {
                    present(addMemberNavigation, animated: true)
                } else {
                    let actionSheet = makeMemberActionSheet(user: members[indexPath.row - 1])
                    present(actionSheet, animated: true)
                }
            } else {
                let actionSheet = makeMemberActionSheet(user: members[indexPath.row])
                present(actionSheet, animated: true)
            }
        default:
            return
        }
    }
}

extension GroupInfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2:
            return isAdmin ? 2 : 1
        case 3:
            return isAdmin ? members.count + 1 : members.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Description"
        case 3:
            return "Members"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let groupInfo else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            let cell: GroupInfoHeaderCell = tableView.makeCell(indexPath: indexPath, selectionStyle: .none)
            cell.render(groupInfo)
            cell.delegate = self
            headerCell = cell
            return cell
        case 1:
            let cell: UITableViewCell = tableView.makeCell(indexPath: indexPath, accessoryType: .disclosureIndicator)
            var content = cell.defaultContentConfiguration()
            content.text = groupDescription.isEmpty ? "Add group description" : groupDescription
            if groupInfo.adminIds.contains(currentUser.id) {
                content.textProperties.color = groupDescription.isEmpty ? Color.blueNative.uiColor : cell.defaultContentConfiguration().textProperties.color
            } else {
                cell.isUserInteractionEnabled = false
                cell.accessoryType = .none
                content.textProperties.color = cell.defaultContentConfiguration().textProperties.color
            }
            cell.contentConfiguration = content
            return cell
        case 2:
            if indexPath.row == 0 {
                let cell: SettingsButtonCell = tableView.makeCell(indexPath: indexPath, accessoryType: .disclosureIndicator)
                let image = Icon.send.image.withTintColor(Color.primary500.uiColor)
                cell.render(.init(icon: image, text: "Start chat"))
                return cell
            } else {
                let cell: UITableViewCell = tableView.makeCell(indexPath: indexPath, accessoryType: .disclosureIndicator)
                var content = cell.defaultContentConfiguration()
                content.text = "Requests to join"
                content.textProperties.color = Color.blueNative.uiColor
                cell.contentConfiguration = content
                return cell
            }
        case 3:
            if isAdmin {
                if indexPath.row == 0 {
                    let cell: UITableViewCell = tableView.makeCell(indexPath: indexPath)
                    var content = cell.defaultContentConfiguration()
                    content.text = "Add new member"
                    content.image = UIImage(systemName: "person.crop.circle.fill.badge.plus")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 28)).withTintColor(Color.blueNative.uiColor)
                    content.imageToTextPadding = 17
                    content.imageProperties.reservedLayoutSize = CGSize(width: 42, height: 42)
                    content.textProperties.color = Color.blueNative.uiColor
                    cell.contentConfiguration = content
                    return cell
                }
                return makeMembersCell(from: tableView, indexPath: indexPath, row: indexPath.row - 1)
            }
            return makeMembersCell(from: tableView, indexPath: indexPath, row: indexPath.row)
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isAdmin {
            return (indexPath.section == 3 && indexPath.row == 0) ? 52 : UITableView.automaticDimension
        }
        return UITableView.automaticDimension
    }
}

extension GroupInfoViewController: GroupInfoHeaderDelegate {
    func didTapOnAvatar(_ image: UIImage) {
        let previewImageView = PreviewAvatarViewController(image: image)
        previewImageView.modalTransitionStyle = .crossDissolve
        previewImageView.modalPresentationStyle = .overFullScreen
        present(previewImageView, animated: true)
    }
}

private extension GroupInfoViewController {
    func makeMembersCell(from tableView: UITableView, indexPath: IndexPath, row: Int) -> UITableViewCell {
        guard members.count > 0 else { return UITableViewCell() }
        let cell: UserCell = tableView.makeCell(indexPath: indexPath, accessoryType: .none)
        let contact = members[row]
        cell.render(contact, isAdmin: isUserAdmin(contact))
        return cell
    }
    
    func configureEditButton() {
        let done = UIBarButtonItem(title: Strings.Commons.edit, style: .done, target: self, action: #selector(didTapEditButton))
        navigationItem.setRightBarButton(done, animated: false)
    }
    
    func isUserAdmin(_ user: User) -> Bool {
        groupInfo?.adminIds.contains(user.id) == true
    }
    
    func makeMemberActionSheet(user: User) -> UIAlertController {
        let isUserAdmin = isUserAdmin(user)
        
        let userInfoAction = UIAlertAction(title: Localizable.ActionSheet.userInfo, style: .default, handler: { [weak self] _ in
            let controller = ContactInfoFactory.make(contactInfo: user, shouldDisplayStartChat: true)
            self?.navigationController?.pushViewController(controller, animated: true)
        })
        
        let makeAdminAction = UIAlertAction(title: Localizable.ActionSheet.makeAdmin, style: .default, handler: { [weak self] _ in
            self?.interactor.updatePrivileges(for: user, isAdmin: true)
        })
        
        let removeAdminAction = UIAlertAction(title: Localizable.ActionSheet.removeAdmin, style: .default, handler: { [weak self] _ in
            self?.interactor.updatePrivileges(for: user, isAdmin: false)
        })
        
        let removeUserAction = UIAlertAction(title: Localizable.ActionSheet.removeUser, style: .destructive, handler: { [weak self] _ in
            self?.interactor.removeMember(user)
        })
        
        let actionSheet = UIAlertController(title: user.name, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(userInfoAction)
        
        if isAdmin {
            if isUserAdmin {
                actionSheet.addAction(removeAdminAction)
            } else {
                actionSheet.addAction(makeAdminAction)
            }
            
            actionSheet.addAction(removeUserAction)
        }
        
        actionSheet.addAction(UIAlertAction(title: Strings.Commons.cancel, style: .cancel, handler: nil))
        
        return actionSheet
    }
}

@objc private extension GroupInfoViewController {
    func didTapEditButton() {
        present(editGroupNavigation, animated: true)
    }
}

