public protocol CoordinatorClientProtocol {
    func downloadRecentChat<T: Codable>(key: String, chatRoomId: String, currentUserId: String, completion: @escaping (Result<T, FirebaseError>) -> Void)
    func downloadGroupWithoutListenner<T: Decodable>(id: String, completion: @escaping ((Result<T, FirebaseError>) -> Void))
}

extension FirebaseClient: CoordinatorClientProtocol {
    public func downloadRecentChat<T: Codable>(key: String, chatRoomId: String, currentUserId: String, completion: @escaping (Result<T, FirebaseError>) -> Void) {
        firebaseReference(.recent)
            .whereField(key, isEqualTo: currentUserId)
            .whereField("chatRoomId", isEqualTo: chatRoomId)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else {
                    completion(.failure(.noDocumentFound))
                    return
                }
                
                guard let recent = documents.compactMap({ try? $0.data(as: T.self) }).first else {
                    completion(.failure(.errorDecodeUser))
                    return
                }
                completion(.success(recent))
            }
    }
    
    public func downloadGroupWithoutListenner<T: Decodable>(id: String, completion: @escaping ((Result<T, FirebaseError>) -> Void)) {
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
}
