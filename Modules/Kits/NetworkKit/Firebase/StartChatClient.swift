import FirebaseFirestore

public struct StartChatDTO {
    let chatRoomId: String
    let chatRoomKey: String
    let membersIdsToCreateRecent: [String]
    let senderKey: String
    
    public init(
        chatRoomId: String,
        chatRoomKey: String,
        membersIdsToCreateRecent: [String],
        senderKey: String
    ) {
        self.chatRoomId = chatRoomId
        self.chatRoomKey = chatRoomKey
        self.membersIdsToCreateRecent = membersIdsToCreateRecent
        self.senderKey = senderKey
    }
}

public protocol StartChatClientProtocol {
    func makeRecentChats(dto: StartChatDTO, completion: @escaping ([String]) -> Void)
    func saveRecent<T: Codable>(id: String, recentChat: T)
}

extension FirebaseClient: StartChatClientProtocol {
    public func makeRecentChats(dto: StartChatDTO, completion: @escaping ([String]) -> Void) {
        firebaseReference(.recent).whereField(dto.chatRoomKey, isEqualTo: dto.chatRoomId).getDocuments { [weak self] snapshot, error in
            guard let self, let snapshot else {
                completion([])
                return
            }
            
            if !snapshot.isEmpty {
                completion(self.removeMemberWhoHasRecent(snapshot: snapshot, memberIds: dto.membersIdsToCreateRecent, storageKey: dto.senderKey))
            } else {
                completion(dto.membersIdsToCreateRecent)
            }
        }
    }
}

private extension FirebaseClient {
    func removeMemberWhoHasRecent(snapshot: QuerySnapshot, memberIds: [String], storageKey: String) -> [String] {
        var membersIdsToCreateRecent = memberIds
        for recentData in snapshot.documents {
            let currentRecent = recentData.data() as Dictionary
            if let currentUserId = currentRecent[storageKey] as? String {
                if membersIdsToCreateRecent.contains(currentUserId) {
                    membersIdsToCreateRecent.remove(at: membersIdsToCreateRecent.firstIndex(of: currentUserId)!)
                }
            }
        }
        return membersIdsToCreateRecent
    }
}
