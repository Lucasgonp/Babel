import NetworkKit

protocol ContactInfoServicing {
    func getContactUser(from id: String, completion: @escaping (Result<User, FirebaseError>) -> Void)
}

final class ContactInfoService {
    private let client: ContactInfoClientProtocol
    
    init(client: ContactInfoClientProtocol) {
        self.client = client
    }
}

// MARK: - ContactInfoServicing
extension ContactInfoService: ContactInfoServicing {
    func getContactUser(from id: String, completion: @escaping (Result<User, FirebaseError>) -> Void) {
        client.downloadUser(id: id, completion: completion)
    }
}
