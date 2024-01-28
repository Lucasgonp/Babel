import NetworkKit

protocol RequestsJoinGroupWorkerProtocol {
    func fetchRequests(usersIds: [String], completion: @escaping (Result<[User], FirebaseError>) -> Void)
    func acceptUser(_ userId: String, groupId: String, completion: @escaping (Error?) -> Void)
    func refuseUser(_ userId: String, groupId: String, completion: @escaping (Error?) -> Void)
}

final class RequestsJoinGroupWorker {
    private let client: RequestJoinGroupClientProtocol
    
    init(client: RequestJoinGroupClientProtocol = FirebaseClient.shared) {
        self.client = client
    }
}

extension RequestsJoinGroupWorker: RequestsJoinGroupWorkerProtocol {
    func fetchRequests(usersIds: [String], completion: @escaping (Result<[User], FirebaseError>) -> Void) {
        client.downloadUsers(withIds: usersIds, completion: completion)
    }
    
    func acceptUser(_ userId: String, groupId: String, completion: @escaping (Error?) -> Void) {
        client.acceptUser(userId, groupId: groupId, completion: completion)
    }
    
    func refuseUser(_ userId: String, groupId: String, completion: @escaping (Error?) -> Void) {
        client.refuseUser(userId, groupId: groupId, completion: completion)
    }
}
