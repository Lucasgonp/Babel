import FirebaseFirestore

public protocol RequestJoinGroupClientProtocol {
    func acceptUser(_ userId: String, groupId: String, completion: @escaping (Error?) -> Void)
    func refuseUser(_ userId: String, groupId: String, completion: @escaping (Error?) -> Void)
    func downloadUsers<T: Decodable>(withIds: [String], completion: @escaping ((Result<[T], FirebaseError>) -> Void))
}

extension FirebaseClient: RequestJoinGroupClientProtocol {
    public func acceptUser(_ userId: String, groupId: String, completion: @escaping (Error?) -> Void) {
        let fields = [
            kMEMBERSIDS: FieldValue.arrayUnion([userId]),
            kREQUESTSTOJOINMEMBERSIDS: FieldValue.arrayRemove([userId])
        ]
        
        firebaseReference(.group).document(groupId).updateData(fields, completion: completion)
    }
    
    public func refuseUser(_ userId: String, groupId: String, completion: @escaping (Error?) -> Void) {
        let fields = [kREQUESTSTOJOINMEMBERSIDS: FieldValue.arrayRemove([userId])]
        firebaseReference(.group).document(groupId).updateData(fields, completion: completion)
    }
}
