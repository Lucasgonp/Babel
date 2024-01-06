public struct ChatMessageDTO {
    let chatRoomId: String
    let messageId: String
    let memberIds: [String]
    let status: [String: Any]
    
    public init(chatRoomId: String, messageId: String, memberIds: [String], status: [String : Any]) {
        self.chatRoomId = chatRoomId
        self.messageId = messageId
        self.memberIds = memberIds
        self.status = status
    }
}
