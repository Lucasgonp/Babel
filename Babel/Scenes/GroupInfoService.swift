import UIKit
import NetworkKit

protocol GroupInfoWorkerProtocol {
    func fetchGroup(from id: String, completion: @escaping (Result<Group, FirebaseError>) -> Void)
    func downloadUsers(with ids: [String], completion: @escaping ((Result<[User], FirebaseError>) -> Void))
    func updateAvatarImage(_ image: UIImage, directory: String, completion: @escaping (String?) -> Void)
    func saveGroupToFirebase(group: Group, completion: @escaping (Error?) -> Void)
}

final class GroupInfoWorker {
    typealias ClientProtocol = GroupClientProtocol & UsersClientProtocol
    private let client: ClientProtocol
    
    init(client: ClientProtocol = FirebaseClient.shared) {
        self.client = client
    }
}

extension GroupInfoWorker: GroupInfoWorkerProtocol {
    func fetchGroup(from id: String, completion: @escaping (Result<Group, FirebaseError>) -> Void) {
        client.downloadGroup(id: id, completion: completion)
    }
    
    func downloadUsers(with ids: [String], completion: @escaping ((Result<[User], FirebaseError>) -> Void)) {
        client.downloadUsers(withIds: ids, completion: completion)
    }
    
    func updateAvatarImage(_ image: UIImage, directory: String, completion: @escaping (String?) -> Void) {
        StorageManager.shared.uploadImage(image, directory: directory, callbackThread: .main, completion: completion)
    }
    
    func saveGroupToFirebase(group: Group, completion: @escaping (Error?) -> Void) {
        client.updateGroupInfo(id: group.id, dto: group, completion: completion)
    }
}
