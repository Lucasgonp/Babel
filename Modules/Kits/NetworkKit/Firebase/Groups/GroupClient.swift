import FirebaseFirestore
import FirebaseFirestoreSwift

public protocol GroupClientProtocol {
    func downloadGroup<T: Decodable>(id: String, completion: @escaping ((Result<T, FirebaseError>) -> Void))
    func updateGroupInfo<T: Encodable>(id: String, dto: T, completion: @escaping (Error?) -> Void)
    func requestToJoin(_ userId: String, groupId: String, completion: @escaping (Error?) -> Void)
    func addMembers(_ memberIds: [String], groupId: String, completion: @escaping (Error?) -> Void)
    func removeMember(_ memberId: String, groupId: String, completion: @escaping (Error?) -> Void)
    func updatePrivileges(isAdmin: Bool, groupId: String, for userId: String, completion: @escaping (Error?) -> Void)
    func updateGroupName(name: String, avatarLink: String, groupId: String)
    func deleteGroup(groupId: String, completion: @escaping (Error?) -> Void)
    func removeListeners()
}

extension FirebaseClient: GroupClientProtocol {
    public func downloadGroup<T: Decodable>(id: String, completion: @escaping ((Result<T, FirebaseError>) -> Void)) {
        groupInfoListenner = firebaseReference(.group).document(id).addSnapshotListener { (querySnapshot, error) in
            if let error {
                return completion(.failure(.custom(error)))
            }
            
            guard let document = querySnapshot else {
                return completion(.failure(.noDocumentFound))
            }
            
            do {
                let user = try document.data(as: T.self)
                completion(.success(user))
            } catch {
                return completion(.failure(.errorDecodeUser))
            }
        }
    }
    
    public func updateGroupInfo<T: Encodable>(id: String, dto: T, completion: @escaping (Error?) -> Void) {
        do {
            try firebaseReference(.group).document(id).setData(from: dto, merge: true, completion: completion)
        } catch {
            print(error.localizedDescription)
            completion(error)
        }
    }
    
    public func updateGroupName(name: String, avatarLink: String, groupId: String) {
        firebaseReference(.recent)
            .whereField("chatRoomId", isEqualTo: groupId).getDocuments { snapshot, error in
                snapshot?.query.whereField("type", isEqualTo: "group").getDocuments(completion: { snapshot, error in
                    guard let documents = snapshot?.documents else { return }
                    
                    for document in documents {
                        let fields = [
                            "groupName": name,
                            "avatarLink": avatarLink
                        ]
                        document.reference.setData(fields, merge: true)
                    }
                })
            }
    }
    
    public func addMembers(_ memberIds: [String], groupId: String, completion: @escaping (Error?) -> Void) {
        let fields = [kMEMBERSIDS: FieldValue.arrayUnion(memberIds)]
        firebaseReference(.group).document(groupId).updateData(fields, completion: completion)
    }
    
    public func requestToJoin(_ userId: String, groupId: String, completion: @escaping (Error?) -> Void) {
        let fields = [kREQUESTSTOJOINMEMBERSIDS: FieldValue.arrayUnion([userId])]
        firebaseReference(.group).document(groupId).updateData(fields, completion: completion)
    }
    
    public func removeMember(_ memberId: String, groupId: String, completion: @escaping (Error?) -> Void) {
        let fields = [kMEMBERSIDS: FieldValue.arrayRemove([memberId])]
        firebaseReference(.group).document(groupId).updateData(fields, completion: completion)
    }
    
    public func updatePrivileges(isAdmin: Bool, groupId: String, for userId: String, completion: @escaping (Error?) -> Void) {
        let fields: [AnyHashable: Any]
        if isAdmin {
            fields = [kADMINIDS: FieldValue.arrayUnion([userId])]
        } else {
            fields = [kADMINIDS: FieldValue.arrayRemove([userId])]
        }
        
        firebaseReference(.group).document(groupId).updateData(fields, completion: completion)
    }
    
    public func deleteGroup(groupId: String, completion: @escaping (Error?) -> Void) {
        firebaseReference(.group).document(groupId).delete(completion: completion)
    }
}
