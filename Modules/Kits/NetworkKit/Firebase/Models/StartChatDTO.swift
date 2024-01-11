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
