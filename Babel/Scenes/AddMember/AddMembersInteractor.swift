protocol AddMembersInteractorProtocol: AnyObject {
    func loadAllUsers()
}

final class AddMembersInteractor {
    private let worker: AddMembersWorkerProtocol
    private let presenter: AddMembersPresenterProtocol

    init(worker: AddMembersWorkerProtocol, presenter: AddMembersPresenterProtocol) {
        self.worker = worker
        self.presenter = presenter
    }
}

extension AddMembersInteractor: AddMembersInteractorProtocol {
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
