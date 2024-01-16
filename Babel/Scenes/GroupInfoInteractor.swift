import Foundation

protocol GroupInfoInteracting: AnyObject {
    func fetchGroupData()
    func updateGroupInfo(dto: EditGroupDTO)
    func updateGroupDesc(_ description: String)
    func addMembers(_ users: [User])
    func removeMember(_ user: User)
    func updatePrivileges(for member: User, isAdmin: Bool)
    func sendMessage()
    func exitGroup()
}

final class GroupInfoInteractor {
    private let worker: GroupInfoWorkerProtocol
    private let presenter: GroupInfoPresenting
    
    private var currentUser: User {
        UserSafe.shared.user
    }
    
    private var membersIds: [String] {
        group?.members.compactMap({ $0.id }) ?? []
    }
    
    private var group: Group?
    private let groupId: String
    private var members = [User]()

    init(worker: GroupInfoWorkerProtocol, presenter: GroupInfoPresenting, groupId: String) {
        self.worker = worker
        self.presenter = presenter
        self.groupId = groupId
    }
}

extension GroupInfoInteractor: GroupInfoInteracting {
    func fetchGroupData() {
        presenter.displayLoading(isLoading: true)
        fetchGroupData { [weak self] group in
            self?.group = group
            let memberIds = group.members.compactMap({ $0.id })
            self?.fetchGroupMembers(ids: memberIds) { [weak self] users in
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
        worker.updateAvatarImage(dto.image, directory: directory) { [weak self] avatarLink in
            guard let self, var group, let avatarLink else { return }
            group.avatarLink = avatarLink
            group.name = dto.name
            self.worker.saveGroupToFirebase(group: group) { [weak self] error in
                guard let self else { return }
                if let error {
                    self.presenter.displayError(message: error.localizedDescription)
                } else {
                    self.group = group
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
    
    func addMembers(_ users: [User]) {
        let members = users.compactMap({ Group.Member(id: $0.id, name: $0.name) })
        worker.addMembers(members, groupId: groupId) { [weak self] error in
            guard let self else { return }
            if let error {
                self.presenter.displayError(message: error.localizedDescription)
            } else {
                self.members.append(contentsOf: users)
                self.group?.members.append(contentsOf: members)
                self.fetchGroupMembers(ids: self.members.compactMap({ $0.id })) { [weak self] users in
                    guard let self else { return }
                    self.presenter.displayGroup(with: self.group!, members: users)
                }
            }
        }
    }
    
    func removeMember(_ user: User) {
        let member = Group.Member(id: user.id, name: user.name)
        worker.removeMember(member, groupId: groupId) { [weak self] error in
            guard let self else { return }
            if let error {
                self.presenter.displayError(message: error.localizedDescription)
            } else {
                self.members.removeAll(where: { $0 == user })
                self.group?.members.removeAll(where: { $0 == member })
                self.presenter.displayGroup(with: self.group!, members: self.members)
            }
        }
    }
    
    func updatePrivileges(for member: User, isAdmin: Bool) {
        worker.updatePrivileges(isAdmin: isAdmin, groupId: groupId, userId: member.id) { [weak self] error in
            guard let self else { return }
            if let error {
                self.presenter.displayError(message: error.localizedDescription)
            } else {
                self.fetchGroupData { [weak self] group in
                    guard let self else { return }
                    self.group = group
                    self.presenter.displayGroup(with: group, members: self.members)
                }
            }
        }
    }
    
    func exitGroup() {
        let isLastAdm = (group?.adminIds.count == 1) && (group?.adminIds.contains({ currentUser.id }()) == true)
        if isLastAdm {
            if group!.members.count > 1 {
                let otherMembers = group!.members.filter({ $0.id != currentUser.id }).first!
                worker.updatePrivileges(isAdmin: true, groupId: groupId, userId: otherMembers.id) { [weak self] error in
                    guard let self else { return }
                    self.worker.exitGroup(groupId: self.groupId) { [weak self] error in
                        guard let self else { return }
                        if let error {
                            self.presenter.displayError(message: error.localizedDescription)
                        } else {
                            StartGroupChat.shared.restartChat(chatRoomId: self.groupId, memberIds: self.membersIds)
                            self.presenter.didNextStep(action: .didExitGroup)
                        }
                    }
                }
            } else {
                // Should delete group
            }
        } else {
            worker.exitGroup(groupId: groupId) { [weak self] error in
                guard let self else { return }
                if let error {
                    self.presenter.displayError(message: error.localizedDescription)
                } else {
                    StartGroupChat.shared.restartChat(chatRoomId: self.groupId, memberIds: self.membersIds)
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
                    self?.presenter.displayLoading(isLoading: false)
                    self?.presenter.displayError(message: error.localizedDescription)
                }
            }
        }
    }
    
    func fetchGroupMembers(ids: [String], completion: @escaping ([User]) -> Void) {
        worker.downloadUsers(with: ids) { [weak self] result in
            switch result {
            case let .success(users):
                completion(users)
            case let .failure(error):
                self?.presenter.displayLoading(isLoading: false)
                self?.presenter.displayError(message: error.localizedDescription)
            }
        }
    }
}
