import NetworkKit
import StorageKit

final class StartChat {
    static let shared = StartChat()
    
    private let client: StartChatClientProtocol & UsersClientProtocol = FirebaseClient.shared
    private let currentUser = UserSafe.shared.user
    
    private init() {}
    
    func startChat(user1: User, user2: User) -> String {
        let chatRoomId = chatRoomIdFrom(user1Id: user1.id, user2Id: user2.id)
        createRecentItems(chatRoomId: chatRoomId, users: [user1, user2])
        return chatRoomId
    }
    
    func restartChat(chatRoomId: String, memberIds: [String]) {
        client.downloadUsers(withIds: memberIds) { [weak self] (result: Result<[User], FirebaseError>) in
            if case .success(let users) = result {
                let users = users.filter({ $0.id != AccountInfo.shared.user?.id })
                if !users.isEmpty {
                    self?.createRecentItems(chatRoomId: chatRoomId, users: users)
                }
            }
        }
    }
}

private extension StartChat {
    func createRecentItems(chatRoomId: String, users: [User]) {
        let dto = StartChatDTO(
            chatRoomId: chatRoomId,
            chatRoomKey: StorageKey.chatRoomId.rawValue,
            membersIdsToCreateRecent: users.compactMap({ $0.id }),
            senderKey: StorageKey.senderId.rawValue
        )
        
        client.makeRecentChats(dto: dto) { [weak self] membersIdsToCreateRecent in
            guard let self else { return }
            
            let receiverUser = self.getReceiverFrom(users: users)
            for userId in membersIdsToCreateRecent {
                let senderUser = userId == currentUser.id ? currentUser : receiverUser
                let receiverUser = userId == currentUser.id ? receiverUser : currentUser
                
                let recentObject = RecentChatModel(
                    id: UUID().uuidString,
                    chatRoomId: chatRoomId,
                    senderId: senderUser.id,
                    senderName: senderUser.name,
                    receiverId: receiverUser.id,
                    receiverName: receiverUser.name,
                    membersId: [senderUser.id, receiverUser.id],
                    lastMassage: String(),
                    unreadCounter: 0,
                    avatarLink: receiverUser.avatarLink
                )
                self.client.saveRecent(id: recentObject.id, recentChat: recentObject)
            }
        }
    }

    func chatRoomIdFrom(user1Id: String, user2Id: String) -> String {
        var chatRoomId = String()
        let value = user1Id.compare(user2Id).rawValue
        
        chatRoomId = value < 0 ? (user1Id + user2Id) : (user2Id + user1Id)
        
        return chatRoomId
    }
    
    func getReceiverFrom(users: [User]) -> User {
        var allUsers = users
        allUsers.remove(at: allUsers.firstIndex(where: { $0.id == currentUser.id })!)
        return allUsers.first!
    }
}
