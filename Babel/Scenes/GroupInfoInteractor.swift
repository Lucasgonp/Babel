import Foundation

protocol GroupInfoInteractorProtocol: AnyObject {
    func fetchGroupData()
    func updateGroupInfo(dto: EditGroupDTO)
    func updateGroupDesc(_ description: String)
    func addMembers(_ users: [User])
    func requestToJoin()
    func removeMember(_ user: User)
    func updatePrivileges(for member: User, isAdmin: Bool)
    func sendMessage()
    func exitGroup()
    func removeListeners()
    func didTapOnRequestsToJoin()
}

final class GroupInfoInteractor {
    private let worker: GroupInfoWorkerProtocol
    private let presenter: GroupInfoPresenterProtocol
    
    private var currentUser: User {
        UserSafe.shared.user
    }
    
    private var membersIds: [String] {
        group?.membersIds ?? []
    }
    
    private var group: Group?
    private let groupId: String
    private var members = [User]()
    private var didDeleteGroup = false
    
    init(worker: GroupInfoWorkerProtocol, presenter: GroupInfoPresenterProtocol, groupId: String) {
        self.worker = worker
        self.presenter = presenter
        self.groupId = groupId
    }
}

extension GroupInfoInteractor: GroupInfoInteractorProtocol {
    func fetchGroupData() {
        presenter.displayLoading(isLoading: true)
        fetchGroupData { [weak self] group in
            self?.group = group
            let memberIds = group.membersIds
            self?.fetchGroupMembers(ids: memberIds) { [weak self] users in
                self?.group?.membersIds = users.compactMap({ $0.id })
                self?.members = users
                DispatchQueue.main.async {
                    self?.presenter.displayLoading(isLoading: false)
                    self?.presenter.displayGroup(with: group, members: users)
                }
            }
        }
    }
    
    func updateGroupInfo(dto: EditGroupDTO) {
        let directory = FileDirectory.avatars.format(groupId)
        worker.updateAvatarImage(dto.avatar, directory: directory) { [weak self] avatarLink in
            guard let self, var group, let avatarLink else { return }
            group.avatarLink = avatarLink
            group.name = dto.name
            self.worker.saveGroupToFirebase(group: group) { [weak self] error in
                guard let self else { return }
                if let error {
                    self.presenter.displayError(message: error.localizedDescription)
                } else {
                    if self.group?.name != dto.name || self.group?.avatarLink != avatarLink {
                        self.worker.saveGroupInRecentChats(group: group)
                    }
                    
                    self.group = group
                    var dto = dto
                    dto.avatarLink = avatarLink
                    self.presenter.updateGroupInfo(dto: dto)
                }
            }
        }
    }
    
    func updateGroupDesc(_ description: String) {
        guard var group = group else { return }
        group.description = description
        worker.saveGroupToFirebase(group: group) { [weak self] error in
            guard let self else { return }
            if let error {
                self.presenter.displayError(message: error.localizedDescription)
            } else {
                self.group = group
                self.presenter.updateGroupDesc(description)
            }
        }
    }
    
    func addMembers(_ members: [User]) {
        let membersIds = members.compactMap({ $0.id })
        worker.addMembers(membersIds, groupId: groupId) { [weak self] error in
            guard let self else { return }
            if let error {
                self.presenter.displayError(message: error.localizedDescription)
            }
        }
    }
    
    func requestToJoin() {
        worker.requestToJoin(groupId: groupId) { [weak self] error in
            if let error {
                self?.presenter.displayError(message: error.localizedDescription)
            }
        }
    }
    
    func removeMember(_ member: User) {
        if group?.adminIds.contains(member.id) == true {
            worker.updatePrivileges(isAdmin: false, groupId: groupId, userId: member.id) { [weak self] error in
                guard let self else { return }
                self.worker.removeMember(member, groupId: groupId) { [weak self] error in
                    guard let self else { return }
                    if let error {
                        self.presenter.displayError(message: error.localizedDescription)
                    } else {
                        self.members.removeAll(where: { $0 == member })
                        self.group?.membersIds.removeAll(where: { $0 == member.id })
                        self.presenter.displayGroup(with: self.group!, members: self.members)
                    }
                }
            }
        } else {
            worker.removeMember(member, groupId: groupId) { [weak self] error in
                guard let self else { return }
                if let error {
                    self.presenter.displayError(message: error.localizedDescription)
                } else {
                    self.members.removeAll(where: { $0 == member })
                    self.group?.membersIds.removeAll(where: { $0 == member.id })
                    self.presenter.displayGroup(with: self.group!, members: self.members)
                }
            }
        }
    }
    
    func updatePrivileges(for member: User, isAdmin: Bool) {
        worker.updatePrivileges(isAdmin: isAdmin, groupId: groupId, userId: member.id) { [weak self] error in
            guard let self else { return }
            if let error {
                self.presenter.displayError(message: error.localizedDescription)
            }
        }
    }
    
    func exitGroup() {
        let isLastAdm = (group?.adminIds.count == 1) && (group?.adminIds.contains({ currentUser.id }()) == true)
        if isLastAdm {
            if group!.membersIds.count > 1 {
                let otherMembers = group!.membersIds.filter({ $0 != currentUser.id }).first!
                worker.updatePrivileges(isAdmin: true, groupId: groupId, userId: otherMembers) { [weak self] error in
                    guard let self else { return }
                    self.worker.exitGroup(groupId: self.groupId) { [weak self] error in
                        guard let self else { return }
                        if let error {
                            self.presenter.displayError(message: error.localizedDescription)
                        } else {
                            StartGroupChat.shared.deleteChat(chatRoomId: self.groupId)
                            self.presenter.didNextStep(action: .didExitGroup)
                        }
                    }
                }
            } else {
                worker.removeListeners()
                worker.exitGroup(groupId: self.groupId) { [weak self] error in
                    guard let self else { return }
                    if let error {
                        self.presenter.displayError(message: error.localizedDescription)
                    } else {
                        StartGroupChat.shared.deleteChat(chatRoomId: self.groupId)
                        self.worker.deleteGroup(groupId: self.groupId)
                        self.presenter.didNextStep(action: .didExitGroup)
                    }
                }
            }
        } else {
            worker.exitGroup(groupId: groupId) { [weak self] error in
                guard let self else { return }
                if let error {
                    self.presenter.displayError(message: error.localizedDescription)
                } else {
                    StartGroupChat.shared.deleteChat(chatRoomId: self.groupId)
                    self.presenter.didNextStep(action: .didExitGroup)
                }
            }
        }
    }
    
    func sendMessage() {
        guard let group else { return }
        let chatId = StartGroupChat.shared.startChat(group: group)
        let chatDTO = ChatGroupDTO(chatId: chatId, groupInfo: group, membersIds: members.compactMap({ $0.id }))
        presenter.didNextStep(action: .pushChatView(dto: chatDTO))
    }
    
    func removeListeners() {
        worker.removeListeners()
    }
    
    func didTapOnRequestsToJoin() {
        guard let group else { return }
        presenter.didNextStep(action: .pushRequestsToJoin(group: group))
    }
}

private extension GroupInfoInteractor {
    func fetchGroupData(completion: @escaping (_ group: Group) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            self.worker.fetchGroup(from: self.groupId) { [weak self] result in
                switch result {
                case let .success(group):
                    completion(group)
                    
                case let .failure(error):
                    DispatchQueue.main.async { [weak self] in
                        self?.presenter.displayLoading(isLoading: false)
                        self?.presenter.displayError(message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func fetchGroupMembers(ids: [String], completion: @escaping ([User]) -> Void) {
        worker.downloadUsers(with: ids) { [weak self] result in
            guard let self, !self.didDeleteGroup else { return }
            
            switch result {
            case let .success(users):
                completion(users)
            case let .failure(error):
                self.presenter.displayLoading(isLoading: false)
                self.presenter.displayError(message: error.localizedDescription)
            }
        }
    }
}
