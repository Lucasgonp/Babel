protocol AddMembersInteracting: AnyObject {
    func loadAllUsers()
}

final class AddMembersInteractor {
    private let worker: AddMembersWorkerProtocol
    private let presenter: AddMembersPresenting

    init(worker: AddMembersWorkerProtocol, presenter: AddMembersPresenting) {
        self.worker = worker
        self.presenter = presenter
    }
}

extension AddMembersInteractor: AddMembersInteracting {
    func loadAllUsers() {
        worker.getAllUsers { [weak self] result in
            switch result {
            case let .success(users):
                self?.presenter.displayViewState(.success(users: users))
            case let .failure(error):
                self?.presenter.displayViewState(.error(message: error.localizedDescription))
            }
        }
    }
}
