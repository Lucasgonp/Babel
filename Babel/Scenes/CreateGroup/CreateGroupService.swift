import NetworkKit

protocol CreateGroupWorkerProtocol {
    func getAllUsers(completion: @escaping (Result<[User], Error>) -> Void)
}

final class CreateGroupWorker {
    private let client: UsersClientProtocol
    
    init(client: UsersClientProtocol = FirebaseClient.shared) {
        self.client = client
    }
}

extension CreateGroupWorker: CreateGroupWorkerProtocol {
    func getAllUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        client.downloadAllUsers { (result: Result<[User], FirebaseError>) in
            switch result {
            case .success(let users):
                let users = users.filter({ $0.id != AccountInfo.shared.user?.id })
                completion(.success(users))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
