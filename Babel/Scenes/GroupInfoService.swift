import NetworkKit

protocol GroupInfoWorkerProtocol {
    func fetchGroup(from id: String, completion: @escaping (Result<Group, FirebaseError>) -> Void)
    func downloadUsers(with ids: [String], completion: @escaping ((Result<[User], FirebaseError>) -> Void))
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
}
