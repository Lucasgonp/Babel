import UIKit

public protocol CreateGroupClientProtocol {
    func addGroup<T: Encodable>(_ group: T, groupId: String, completion: @escaping (FirebaseError?) -> Void)
}

extension FirebaseClient: CreateGroupClientProtocol {
    public func addGroup<T: Encodable>(_ group: T, groupId: String, completion: @escaping (FirebaseError?) -> Void) {
        do {
            try firebaseReference(.group).document(groupId).setData(from: group) { error in
                if let error {
                    completion(.custom(error))
                } else {
                    completion(nil)
                }
            }
        } catch {
            completion(.custom(error))
        }
    }
}

private extension FirebaseClient {
}

