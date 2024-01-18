import Foundation

protocol UsersInteractorProtocol: AnyObject {
    func loadAllUsers()
    func refreshAllUsers()
}

final class UsersInteractor {
    private let service: UsersWorkerProtocol
    private let presenter: UsersPresenterProtocol
    private var users = [User]()
    
    init(service: UsersWorkerProtocol, presenter: UsersPresenterProtocol) {
        self.service = service
        self.presenter = presenter
    }
}

extension UsersInteractor: UsersInteractorProtocol {
    func loadAllUsers() {
        DispatchQueue.global().async { [weak self] in
            self?.service.getAllUsers { [weak self] result in
                switch result {
                case .success(let users):
                    if self?.users != users {
                        self?.users = users
                        DispatchQueue.main.async { [weak self] in
                            if !Thread.isMainThread {
                                fatalError("NOT runnign on main thread")
                            }
                            self?.presenter.displayViewState(.success(users: users))
                        }
                    }
                case .failure(let error):
                    self?.presenter.displayViewState(.error(message: error.localizedDescription))
                }
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
