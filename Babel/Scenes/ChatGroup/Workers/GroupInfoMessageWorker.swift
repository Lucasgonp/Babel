import UIKit
import NetworkKit

protocol GroupInfoMessageWorkerProtocol {
    func fetchGroup(from id: String, completion: @escaping (Result<Group, FirebaseError>) -> Void)
}

final class GroupInfoMessageWorker {
    typealias ClientProtocol = GroupClientProtocol
    
    private let client: ClientProtocol
    
    init(client: ClientProtocol = FirebaseClient.shared) {
        self.client = client
    }
}

extension GroupInfoMessageWorker: GroupInfoMessageWorkerProtocol {
    func fetchGroup(from id: String, completion: @escaping (Result<Group, FirebaseError>) -> Void) {
        client.downloadGroup(id: id, completion: completion)
    }
}
