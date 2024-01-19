//import UIKit
//import NetworkKit
//
//protocol GroupChatWorkerProtocol {
//    func fetchGroup(from id: String, completion: @escaping (Result<Group, FirebaseError>) -> Void)
//}
//
//final class GroupChatWorker {
//    typealias ClientProtocol = GroupClientProtocol
//    
//    private let client: ClientProtocol
//    
//    init(client: ClientProtocol = FirebaseClient.shared) {
//        self.client = client
//    }
//}
//
//extension GroupChatWorker: GroupChatWorkerProtocol {
//    func fetchGroup(from id: String, completion: @escaping (Result<Group, FirebaseError>) -> Void) {
//        client.downloadGroup(id: id, completion: completion)
//    }
//}
