public protocol RecentChatClientProtocol {
    func downloadRecentChats<T: Codable>(key: String, currentUserId: String, completion: @escaping (_ allRecents: [T]) -> Void)
    func downloadRecentGroup<T: Decodable>(id: String, completion: @escaping ((Result<T, FirebaseError>) -> Void))
    func deleteRecentChat(_ id: String)
    func deleteRecentChat(key: String, currentUserId: String)
    func updateRecentChat<T: Codable>(id: String, recentChat: T)
}

extension FirebaseClient: RecentChatClientProtocol {
    public func downloadRecentChats<T: Codable>(key: String, currentUserId: String, completion: @escaping (_ allRecents: [T]) -> Void) {
        firebaseReference(.recent).whereField(key, isEqualTo: currentUserId).addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                completion([])
                return
            }
            
            let allRecents = documents.compactMap({ try? $0.data(as: T.self) })
            completion(allRecents)
        }
    }
    
    public func downloadRecentGroup<T: Decodable>(id: String, completion: @escaping ((Result<T, FirebaseError>) -> Void)) {
        firebaseReference(.group).document(id).addSnapshotListener { (querySnapshot, error) in
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
    
    public func deleteRecentChat(_ id: String) {
        firebaseReference(.recent).document(id).delete()
    }
    
    public func deleteRecentChat(key: String, currentUserId: String) {
        firebaseReference(.recent).whereField(key, isEqualTo: currentUserId).getDocuments { [weak self] snapshot, error in
            guard let documents = snapshot?.documents, let document = documents.first else {
                return
            }
            self?.firebaseReference(.recent).document(document.documentID).delete()
        }
    }
    
    public func updateRecentChat<T: Codable>(id: String, recentChat: T) {
        saveRecent(id: id, recentChat: recentChat)
    }
}
