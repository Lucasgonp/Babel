import NetworkKit
protocol GroupsWorkerProtocol {
    func fetchAllGroups(completion: @escaping ((Result<[Group], FirebaseError>) -> Void))
}

final class GroupsWorker {
    private let client: AllGroupsClientProtocol
    
    init(client: AllGroupsClientProtocol = FirebaseClient.shared) {
        self.client = client
    }
}

extension GroupsWorker: GroupsWorkerProtocol {
    func fetchAllGroups(completion: @escaping ((Result<[Group], FirebaseError>) -> Void)) {
        client.downloadAllGroups(completion: completion)
    }
}
