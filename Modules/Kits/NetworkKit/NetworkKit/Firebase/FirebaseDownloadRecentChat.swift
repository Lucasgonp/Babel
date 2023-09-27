public protocol DownloadRecentChatProtocol {
    func downloadRecentChats<T: Codable>(key: String, currentUserId: String, completion: @escaping (_ allRecents: [T]) -> Void)
}

extension FirebaseClient: DownloadRecentChatProtocol {
    public func downloadRecentChats<T: Codable>(key: String, currentUserId: String, completion: @escaping (_ allRecents: [T]) -> Void) {
        firebaseReference(.recent).whereField(key, isEqualTo: currentUserId).addSnapshotListener { snapshot, error in
            var recentChats = [T]()
            guard let documents = snapshot?.documents else {
                completion([])
                return
            }
            
            let allRecents = documents.compactMap({ try? $0.data(as: T.self) })
            completion(allRecents)
        }
    }
}
