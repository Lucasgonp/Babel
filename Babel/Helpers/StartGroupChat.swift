import NetworkKit
import StorageKit

final class StartGroupChat {
    static let shared = StartGroupChat()
    
    private let client: StartChatClientProtocol & RecentChatClientProtocol = FirebaseClient.shared
    private let currentUser = UserSafe.shared.user
    
    private init() {}
    
    func startChat(group: Group) -> String {
        let chatRoomId = chatRoomIdFrom(senderId: currentUser.id, groupId: group.id)
        createRecentItems(chatRoomId: chatRoomId, group: group)
        return chatRoomId
    }
    
    func createRecentItems(chatRoomId: String, group: Group) {
        let dto = StartChatDTO(
            chatRoomId: group.id,
            chatRoomKey: StorageKey.chatRoomId.rawValue,
            membersIdsToCreateRecent: group.members.compactMap({ $0.id }),
            senderKey: StorageKey.senderId.rawValue
        )
        
        client.makeRecentChats(dto: dto) { [weak self] membersIdsToCreateRecent in
            guard let self else { return }
            
            for userId in membersIdsToCreateRecent {
                let currentMember = group.members.first(where: { $0.id == self.currentUser.id })!
                let receiverMember = group.members.first(where: { $0.id == userId })!
                
                let senderUser = userId == currentUser.id ? currentMember : receiverMember
                let receiverUser = userId == currentUser.id ? receiverMember : currentMember
                
                let memberIds = group.members.compactMap({ $0.id })
                
                let recentObject = RecentChatModel(
                    id: UUID().uuidString,
                    chatRoomId: chatRoomId,
                    senderId: senderUser.id,
                    senderName: senderUser.name,
                    receiverId: userId,
                    receiverName: receiverUser.name,
                    membersId: memberIds,
                    lastMassage: String(),
                    unreadCounter: 0,
                    avatarLink: group.avatarLink,
                    groupName: group.name,
                    type: .group
                )
                self.client.saveRecent(id: recentObject.id, recentChat: recentObject)
            }
        }
    }
    
    func deleteChat(chatRoomId: String, memberIds: [String]) {
        client.deleteRecentChat(key: StorageKey.senderId.rawValue, currentUserId: currentUser.id)
    }
}

private extension StartGroupChat {
    func getReceiverFrom(users: [Group.Member]) -> Group.Member {
        var allUsers = users
        if let currentUser = allUsers.firstIndex(where: { $0.id == currentUser.id }) {
            allUsers.remove(at: currentUser)
        }
        return allUsers.first!
    }
    
    func chatRoomIdFrom(senderId: String, groupId: String) -> String {
        return groupId
    }
}
