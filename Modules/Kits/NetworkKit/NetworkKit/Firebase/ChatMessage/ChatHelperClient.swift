public protocol ChatHelperClientProtocol {
    func resetRecentCounter<T: Codable>(dto: ChatHelperDTO, completion: @escaping ([T]) -> Void)
    func saveRecent<T: Codable>(id: String, recentChat: T)
}

extension FirebaseClient: ChatHelperClientProtocol {
    public func resetRecentCounter<T: Codable>(dto: ChatHelperDTO, completion: @escaping ([T]) -> Void) {
        firebaseReference(.recent)
            .whereField(dto.chatRoomId, isEqualTo: dto.chatRoomId)
            .whereField(dto.senderKey, isEqualTo: dto.currentUserId)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("No documents for recent")
                    completion([])
                    return
                }
                
                let allRecents = documents.compactMap({ try? $0.data(as: T.self) })
                completion(allRecents)
            }
    }
}
