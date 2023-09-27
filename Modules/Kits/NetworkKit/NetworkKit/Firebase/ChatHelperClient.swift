public struct ChatHelperDTO {
    let chatRoomId: String
    let chatRoomKey: String
    let senderKey: String
    let currentUserId: String
    
    public init(chatRoomId: String, chatRoomKey: String, senderKey: String, currentUserId: String) {
        self.chatRoomId = chatRoomId
        self.chatRoomKey = chatRoomKey
        self.senderKey = senderKey
        self.currentUserId = currentUserId
    }
}

public protocol ChatHelperClientProtocol {
    func resetRecentCounter<T: Codable>(dto: ChatHelperDTO, completion: @escaping ([T]) -> Void)
    func saveRecentChat<T: Codable>(id: String, recentChat: T)
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
