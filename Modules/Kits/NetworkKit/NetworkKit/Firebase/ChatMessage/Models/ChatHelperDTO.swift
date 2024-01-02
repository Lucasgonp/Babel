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
