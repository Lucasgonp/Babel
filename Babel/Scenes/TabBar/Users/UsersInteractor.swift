import Foundation

protocol UsersInteractorProtocol: AnyObject {
    func loadAllUsers()
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
        DispatchQueue.global().async {
            self.service.getAllUsers { [weak self] result in
                switch result {
                case .success(let users):
                    self?.presenter.displayViewState(.success(users: users))
                case .failure(let error):
                    self?.presenter.displayViewState(.error(message: error.localizedDescription))
                }
            }
        }
    }
}
