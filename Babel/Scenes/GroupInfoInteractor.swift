import Foundation

protocol GroupInfoInteracting: AnyObject {
    func fetchGroupData()
    func updateGroupInfo(dto: EditGroupDTO)
    func updateGroupDesc(_ description: String)
}

final class GroupInfoInteractor {
    private let worker: GroupInfoWorkerProtocol
    private let presenter: GroupInfoPresenting
    
    private var currentUser: User {
        UserSafe.shared.user
    }
    
    private var group: Group?
    private let groupId: String
    private var shouldDisplayStartChat = true

    init(worker: GroupInfoWorkerProtocol, presenter: GroupInfoPresenting, groupId: String) {
        self.worker = worker
        self.presenter = presenter
        self.groupId = groupId
    }
}

extension GroupInfoInteractor: GroupInfoInteracting {
    func fetchGroupData() {
        presenter.displayLoading(isLoading: true)
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            self.worker.fetchGroup(from: self.groupId) { [weak self] result in
                switch result {
                case let .success(group):
                    self?.group = group
                    let memberIds = group.members.compactMap({ $0.id })
                    self?.fetchGroupMembers(ids: memberIds) { [weak self] users in
                        DispatchQueue.main.async {
                            self?.presenter.displayLoading(isLoading: false)
                            self?.presenter.displayGroup(with: group, members: users, shouldDisplayStartChat: true)
                        }
                    }
                case let .failure(error):
                    self?.presenter.displayLoading(isLoading: false)
                    self?.presenter.displayError(message: error.localizedDescription)
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
}

private extension GroupInfoInteractor {
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
