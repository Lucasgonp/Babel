import UIKit
import NetworkKit

protocol CreateGroupWorkerProtocol {
    func getAllUsers(completion: @escaping (Result<[User], Error>) -> Void)
    func uploadAvatarImage(_ image: UIImage, directory: String, completion: (@escaping (_ documentLink: String?) -> Void))
    func addGroup(_ group: Group, completion: @escaping (FirebaseError?) -> Void)
}

final class CreateGroupWorker {
    typealias ClientProtocol = UsersClientProtocol & CreateGroupClientProtocol
    
    private let client: ClientProtocol
    
    init(client: ClientProtocol = FirebaseClient.shared) {
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
    
    func uploadAvatarImage(_ image: UIImage, directory: String, completion: (@escaping (_ documentLink: String?) -> Void)) {
        StorageManager.shared.uploadImage(image, directory: directory, completion: completion)
    }
    
    func addGroup(_ group: Group, completion: @escaping (FirebaseError?) -> Void) {
        client.addGroup(group, groupId: group.id, completion: completion)
    }
}
