protocol CreateGroupInteracting: AnyObject {
    func loadAllUsers()
}

final class CreateGroupInteractor {
    private let worker: CreateGroupWorkerProtocol
    private let presenter: CreateGroupPresenting

    init(worker: CreateGroupWorkerProtocol, presenter: CreateGroupPresenting) {
        self.worker = worker
        self.presenter = presenter
    }
}

extension CreateGroupInteractor: CreateGroupInteracting {
    func loadAllUsers() {
        worker.getAllUsers { [weak self] result in
            switch result {
            case let .success(users):
                self?.presenter.displayAllUsers(users)
            case let .failure(error):
                fatalError("error: \(error.localizedDescription)")
            }
        }
    }
}
