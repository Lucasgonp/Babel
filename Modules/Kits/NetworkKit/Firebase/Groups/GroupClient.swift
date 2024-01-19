import FirebaseFirestore
import FirebaseFirestoreSwift

public protocol GroupClientProtocol {
    func downloadGroup<T: Decodable>(id: String, completion: @escaping ((Result<T, FirebaseError>) -> Void))
    func updateGroupInfo<T: Encodable>(id: String, dto: T, completion: @escaping (Error?) -> Void)
    func addMembers<T: Encodable>(_ members: [T], groupId: String, completion: @escaping (Error?) -> Void)
    func removeMember<T: Encodable>(_ member: T, groupId: String, completion: @escaping (Error?) -> Void)
    func updatePrivileges(isAdmin: Bool, groupId: String, for userId: String, completion: @escaping (Error?) -> Void)
    func updateGroupName(name: String, avatarLink: String, groupId: String)
}

extension FirebaseClient: GroupClientProtocol {
    public func downloadGroup<T: Decodable>(id: String, completion: @escaping ((Result<T, FirebaseError>) -> Void)) {
        firebaseReference(.group).document(id).getDocument { (querySnapshot, error) in
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
    
    public func addMembers<T: Encodable>(_ members: [T], groupId: String, completion: @escaping (Error?) -> Void) {
        do {
            let encodedMembers = try members.compactMap({ try Firestore.Encoder().encode($0) })
            let fields = [kMEMBERS: FieldValue.arrayUnion(encodedMembers)]
            firebaseReference(.group).document(groupId).updateData(fields, completion: completion)
        } catch {
            completion(error)
        }
    }
    
    public func removeMember<T: Encodable>(_ member: T, groupId: String, completion: @escaping (Error?) -> Void) {
        do {
            let encodedMember = try Firestore.Encoder().encode(member)
            let fields = [kMEMBERS: FieldValue.arrayRemove([encodedMember])]
            firebaseReference(.group).document(groupId).updateData(fields, completion: completion)
        } catch {
            completion(error)
        }
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
}
