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

private extension GroupInfoViewController.Layout {
    enum Texts {
        static let title = Strings.GroupInfo.title.localized()
        static let members = Strings.GroupInfo.members.localized()
        static let addGroupDescription = Strings.GroupInfo.addGroupDescription.localized()
        static let sendMessage = Strings.Commons.sendMessage.localized()
        static let joinGroup = Strings.GroupInfo.joinGroup.localized()
        static let exitGroup = Strings.GroupInfo.exitGroup.localized()
        static let addNewMember = Strings.GroupInfo.addNewMember.localized()
        static let edit = Strings.Commons.edit.localized()
        
        static let joinGroupQuestion = Strings.GroupInfo.ActionSheet.joinGroupQuestion.localized()
        static let exitGroupQuestion = Strings.GroupInfo.ActionSheet.exitGroupQuestion.localized()
        static let userInfo = Strings.GroupInfo.ActionSheet.userInfo.localized()
        static let makeAdmin = Strings.GroupInfo.ActionSheet.makeAdmin.localized()
        static let removeAdmin = Strings.GroupInfo.ActionSheet.removeAdmin.localized()
        static let removeMember = Strings.GroupInfo.ActionSheet.removeMember.localized()
    }
}

final class GroupInfoViewController: ViewController<GroupInfoInteractorProtocol, UIView> {
    fileprivate enum Layout { }
    
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
        let editGroupController = EditGroupViewController(name: groupInfo!.name, avatarLink: groupInfo!.avatarLink)
        editGroupController.completion = { [weak self] dto in
            self?.showLoading(backgroupColor: .clear, shouldBlur: true)
            self?.didUpdateGroup = true
            self?.headerCell?.update(dto)
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
    
    private var groupDescription = String()
    
    private var headerCell: GroupInfoHeaderCell?
    private var currentUser: User { UserSafe.shared.user }
    private var isAdmin: Bool {
        groupInfo?.adminIds.contains(currentUser.id) == true
    }
    private var isMember: Bool {
        let memberIds = members.compactMap({ $0.id })
        return memberIds.contains(currentUser.id) == true
    }
    
    private var groupInfo: Group?
    private var members = [User]()
    
    weak var delegate: GroupInfoUpdateProtocol?
    
    private var didUpdateGroup = false
    private var editGroupDTO: EditGroupDTO?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.fetchGroupData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let editGroupDTO, didUpdateGroup else { return }
        delegate?.didUpdateGroupInfo(dto: editGroupDTO)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }

    override func buildViewHierarchy() {
        view.fillWithSubview(subview: tableView)
    }

    override func configureViews() {
        let backButton = UIBarButtonItem(title: String(), style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        title = Layout.Texts.title
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
            groupInfo?.name = dto.name
            groupInfo?.avatarLink = dto.avatarLink
            editGroupDTO = dto
            hideLoading()
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
        case 2:
            if isMember {
                interactor.sendMessage()
            } else {
                let actionSheet = makeJoinGroupActionSheet(user: members[indexPath.row])
                present(actionSheet, animated: true)
            }
        case 3:
            if isAdmin {
                if indexPath.row == 0 {
                    let controller = AddMembersFactory.make(groupMembers: members) { [weak self] users in
                        self?.interactor.addMembers(users)
                    }
                    let navigation = UINavigationController(rootViewController: controller)
                    present(navigation, animated: true)
                } else {
                    let actionSheet = makeMemberActionSheet(user: members[indexPath.row - 1])
                    present(actionSheet, animated: true)
                }
            } else {
                let actionSheet = makeMemberActionSheet(user: members[indexPath.row])
                present(actionSheet, animated: true)
            }
        case 4:
            let actionSheet = makeExitGroupActionSheet(user: members[indexPath.row])
            present(actionSheet, animated: true)
        default:
            return
        }
    }
}

extension GroupInfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return isMember ? 5 : 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2:
            return 1
        case 3:
            return isAdmin ? members.count + 1 : members.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return Strings.Commons.description
        case 3:
            return Layout.Texts.members
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
            content.text = groupDescription.isEmpty ? Layout.Texts.addGroupDescription : groupDescription
            content.textProperties.color = groupDescription.isEmpty ? Color.blueNative.uiColor : cell.defaultContentConfiguration().textProperties.color
            cell.contentConfiguration = content
            return cell
        case 2:
            if isMember {
                let cell: SettingsButtonCell = tableView.makeCell(indexPath: indexPath, accessoryType: .disclosureIndicator)
                let image = Icon.send.image.withTintColor(Color.primary500.uiColor)
                cell.render(.init(icon: image, text: Layout.Texts.sendMessage))
                return cell
            } else {
                let cell: UITableViewCell = tableView.makeCell(indexPath: indexPath, accessoryType: .disclosureIndicator)
                var content = cell.defaultContentConfiguration()
                content.text = Layout.Texts.joinGroup
                content.textProperties.color = Color.blueNative.uiColor
                cell.contentConfiguration = content
                return cell
            }
        case 3:
            if isAdmin {
                if indexPath.row == 0 {
                    let cell: UITableViewCell = tableView.makeCell(indexPath: indexPath)
                    var content = cell.defaultContentConfiguration()
                    content.text = Layout.Texts.addNewMember
                    content.image = UIImage(systemName: "person.crop.circle.fill.badge.plus")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 26)).withTintColor(Color.blueNative.uiColor)
                    content.imageToTextPadding = 17
                    content.imageProperties.reservedLayoutSize = CGSize(width: 42, height: 42)
                    content.textProperties.color = Color.blueNative.uiColor
                    cell.contentConfiguration = content
                    return cell
                }
                return makeMembersCell(from: tableView, indexPath: indexPath, row: indexPath.row - 1)
            }
            return makeMembersCell(from: tableView, indexPath: indexPath, row: indexPath.row)
        case 4:
            let button = Button()
            button.setTitle(Layout.Texts.exitGroup, for: .normal)
            button.setTitleColor(Color.warning500.uiColor, for: .normal)
            let cell = UITableViewCell()
            cell.fillWithSubview(subview: button, spacing: .init(top: 6, left: .zero, bottom: 6, right: .zero))
            return cell
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
        let done = UIBarButtonItem(title: Layout.Texts.edit, style: .done, target: self, action: #selector(didTapEditButton))
        navigationItem.setRightBarButton(done, animated: false)
    }
    
    func isUserAdmin(_ user: User) -> Bool {
        groupInfo?.adminIds.contains(user.id) == true
    }
    
    func makeMemberActionSheet(user: User) -> UIAlertController {
        let isUserAdmin = isUserAdmin(user)
        
        let userInfoAction = UIAlertAction(title: Layout.Texts.userInfo, style: .default, handler: { [weak self] _ in
            let controller = ContactInfoFactory.make(contactInfo: user, shouldDisplayStartChat: true)
            self?.navigationController?.pushViewController(controller, animated: true)
        })
        
        let makeAdminAction = UIAlertAction(title: Layout.Texts.makeAdmin, style: .default, handler: { [weak self] _ in
            self?.interactor.updatePrivileges(for: user, isAdmin: true)
        })
        
        let removeAdminAction = UIAlertAction(title: Layout.Texts.removeAdmin, style: .default, handler: { [weak self] _ in
            self?.interactor.updatePrivileges(for: user, isAdmin: false)
        })
        
        let removeUserAction = UIAlertAction(title: Layout.Texts.removeMember, style: .destructive, handler: { [weak self] _ in
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
    
    func makeExitGroupActionSheet(user: User) -> UIAlertController {
        let exitGroupAction = UIAlertAction(title: Layout.Texts.exitGroup, style: .default, handler: { [weak self] _ in
            self?.interactor.exitGroup()
        })
        
        let actionSheet = UIAlertController(title: Layout.Texts.exitGroup, message: Layout.Texts.exitGroupQuestion, preferredStyle: .actionSheet)
        actionSheet.addAction(exitGroupAction)
        actionSheet.addAction(UIAlertAction(title: Strings.Commons.cancel, style: .cancel, handler: nil))
        
        return actionSheet
    }
    
    func makeJoinGroupActionSheet(user: User) -> UIAlertController {
        let joinGroupAction = UIAlertAction(title: Layout.Texts.joinGroup, style: .default, handler: { [weak self] _ in
            guard let self else { return }
            self.interactor.addMembers([self.currentUser])
        })
        
        let actionSheet = UIAlertController(title: Layout.Texts.joinGroup, message: Layout.Texts.joinGroupQuestion, preferredStyle: .alert)
        actionSheet.addAction(joinGroupAction)
        actionSheet.addAction(UIAlertAction(title: Strings.Commons.cancel, style: .cancel, handler: nil))
        
        return actionSheet
    }
}

@objc private extension GroupInfoViewController {
    func didTapEditButton() {
        present(editGroupNavigation, animated: true)
    }
}

