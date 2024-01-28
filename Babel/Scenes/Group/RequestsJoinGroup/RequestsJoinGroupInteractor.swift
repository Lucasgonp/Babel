protocol RequestsJoinGroupInteractorProtocol: AnyObject {
    func fetchRequests()
    func approveUser(id: String)
    func denyUser(id: String)
}

final class RequestsJoinGroupInteractor {
    private let worker: RequestsJoinGroupWorker
    private let presenter: RequestsJoinGroupPresenterProtocol
    
    private let usersIds: [String]
    private let groupId: String

    init(
        worker: RequestsJoinGroupWorker,
        presenter: RequestsJoinGroupPresenterProtocol,
        usersIds: [String],
        groupId: String
    ) {
        self.worker = worker
        self.presenter = presenter
        self.usersIds = usersIds
        self.groupId = groupId
    }
}

extension RequestsJoinGroupInteractor: RequestsJoinGroupInteractorProtocol {
    func fetchRequests() {
        if usersIds.count == 0 {
            presenter.displayUsers([])
        } else {
            worker.fetchRequests(usersIds: usersIds) { [weak self] result in
                switch result {
                case let .success(users):
                    self?.presenter.displayUsers(users)
                case let .failure(error):
                    self?.presenter.displayError(message: error.localizedDescription)
                }
            }
        }
    }
    
    func approveUser(id: String) {
        worker.acceptUser(id, groupId: groupId) { [weak self] error in
            if let error {
                self?.presenter.displayError(message: error.localizedDescription)
            } else {
                self?.presenter.updateRequests(id)
            }
            
        }
    }
    
    func denyUser(id: String) {
        worker.refuseUser(id, groupId: groupId) { [weak self] error in
            if let error {
                self?.presenter.displayError(message: error.localizedDescription)
            } else {
                self?.presenter.updateRequests(id)
            }
        }
    }
}
