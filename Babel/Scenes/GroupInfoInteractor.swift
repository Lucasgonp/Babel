import Foundation

protocol GroupInfoInteracting: AnyObject {
    func fetchGroupData()
}

final class GroupInfoInteractor {
    private let worker: GroupInfoWorkerProtocol
    private let presenter: GroupInfoPresenting
    
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
                    self?.fetchGroupMembers(ids: group.memberIds) { [weak self] users in
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
