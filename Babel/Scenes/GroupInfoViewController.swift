import UIKit
import DesignKit
import GalleryKit

protocol GroupInfoDisplaying: AnyObject {
    func displayViewState(_ state: GroupInfoViewState)
}

enum GroupInfoViewState {
    case success(groupInfo: Group, members: [User], shouldDisplayStartChat: Bool)
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
    
    private var groupDescription = String()
    
    private var headerCell: GroupInfoHeaderCell?
    
    private var currentUser: User { UserSafe.shared.user }
    
    private var groupInfo: Group?
    private var members = [User]()
    
    weak var delegate: SettingsViewDelegate?
    
    private var shouldDisplayStartChat = true
    
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
        case let .success(groupInfo, members, shouldDisplayStartChat):
            self.groupInfo = groupInfo
            self.members = members
            self.shouldDisplayStartChat = shouldDisplayStartChat
            self.groupDescription = groupInfo.description
            
            if currentUser.id == groupInfo.adminId {
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
        
        if indexPath.section == 1 {
            present(groupDescNavigation, animated: true)
        }
    }
}

extension GroupInfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return shouldDisplayStartChat ? 4 : 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shouldDisplayStartChat { return section == 3 ? members.count : 1 }
        return section == 2 ? members.count : 1
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
            if currentUser.id == groupInfo.adminId {
                content.textProperties.color = groupDescription.isEmpty ? Color.blueNative.uiColor : cell.defaultContentConfiguration().textProperties.color
            } else {
                cell.isUserInteractionEnabled = false
            }
            cell.contentConfiguration = content
            return cell
        case 2:
            if shouldDisplayStartChat {
                let cell: SettingsButtonCell = tableView.makeCell(indexPath: indexPath, accessoryType: .disclosureIndicator)
                let image = Icon.send.image.withTintColor(Color.primary500.uiColor)
                cell.render(.init(icon: image, text: "Start chat"))
                return cell
            } else {
                return makeMembersCell(from: tableView, indexPath: indexPath)
            }
        case 3:
            return makeMembersCell(from: tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
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
    func makeMembersCell(from tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        guard members.count > 0 else { return UITableViewCell() }
        let cell: UserCell = tableView.makeCell(indexPath: indexPath, accessoryType: .none)
        let contact = members[indexPath.row]
        cell.render(contact, isAdmin: contact.id == groupInfo?.adminId)
        return cell
    }
    
    func configureEditButton() {
        let done = UIBarButtonItem(title: Strings.Commons.edit, style: .done, target: self, action: #selector(didTapEditButton))
        navigationItem.setRightBarButton(done, animated: false)
    }
}

@objc private extension GroupInfoViewController {
    func didTapEditButton() {
        present(editGroupNavigation, animated: true)
    }
}

