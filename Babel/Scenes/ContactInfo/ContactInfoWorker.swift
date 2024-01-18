import NetworkKit

protocol ContactInfoWorkerProtocol {
    func getContactUser(from id: String, completion: @escaping (Result<User, FirebaseError>) -> Void)
}

final class ContactInfoWorker {
    private let client: ContactInfoClientProtocol
    
    init(client: ContactInfoClientProtocol) {
        self.client = client
    }
}

extension ContactInfoWorker: ContactInfoWorkerProtocol {
    func getContactUser(from id: String, completion: @escaping (Result<User, FirebaseError>) -> Void) {
        client.downloadUser(id: id, completion: completion)
    }
}
