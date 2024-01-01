public protocol RecentChatClientProtocol {
    func downloadRecentChats<T: Codable>(key: String, currentUserId: String, completion: @escaping (_ allRecents: [T]) -> Void)
    func deleteRecentChat(_ id: String)
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
    
    public func deleteRecentChat(_ id: String) {
        firebaseReference(.recent).document(id).delete()
    }
    
    public func updateRecentChat<T: Codable>(id: String, recentChat: T) {
        saveRecent(id: id, recentChat: recentChat)
    }
}
