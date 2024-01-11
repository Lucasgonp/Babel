import NetworkKit
protocol GroupsWorkerProtocol {
    func getAllGroups()
}

final class GroupsWorker {
    private let client: AllGroupsClientProtocol
    
    init(client: AllGroupsClientProtocol = FirebaseClient.shared) {
        self.client = client
    }
}

extension GroupsWorker: GroupsWorkerProtocol {
    func getAllGroups() {
//        client.downloadAllGroups(completion: <#T##((Result<[Decodable], FirebaseError>) -> Void)##((Result<[Decodable], FirebaseError>) -> Void)##(Result<[Decodable], FirebaseError>) -> Void#>)
    }
}
