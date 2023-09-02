protocol UsersInteracting: AnyObject {
    func loadAllUsers()
    func refreshAllUsers()
}

final class UsersInteractor {
    private let service: UsersServicing
    private let presenter: UsersPresenting
    private var users = [User]()
    
    init(service: UsersServicing, presenter: UsersPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - UsersInteracting
extension UsersInteractor: UsersInteracting {
    func loadAllUsers() {
        service.getAllUsers { [weak self] result in
            switch result {
            case .success(let users):
                if self?.users != users {
                    self?.users = users
                    self?.presenter.displayViewState(.success(users: users))
                }
            case .failure(let error):
                self?.presenter.displayViewState(.error(message: error.localizedDescription))
            }
        }
    }
    
    func refreshAllUsers() {
        service.getAllUsers { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
                self?.presenter.displayViewState(.success(users: users))
            case .failure(let error):
                self?.presenter.displayViewState(.error(message: error.localizedDescription))
            }
        }
    }
}
