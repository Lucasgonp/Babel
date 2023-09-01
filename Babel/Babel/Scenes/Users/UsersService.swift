import NetworkKit

protocol UsersServicing {
    func getAllUsers(completion: @escaping (Result<[User], Error>) -> Void)
}

final class UsersService {
    private let firebaseClient: FirebaseUsersProtocol
    
    init(firebaseClient: FirebaseUsersProtocol) {
        self.firebaseClient = firebaseClient
    }
}

// MARK: - UsersServicing
extension UsersService: UsersServicing {
    func getAllUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        firebaseClient.downloadAllUsers { (result: Result<[User], FirebaseError>) in
            switch result {
            case .success(let users):
                var users = users.filter({ $0.id != AccountInfo.shared.user?.id })
                completion(.success(users))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
