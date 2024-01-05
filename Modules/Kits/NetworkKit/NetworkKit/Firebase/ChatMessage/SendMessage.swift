public protocol SendMessageProtocol {
    func addMessage<T: Encodable>(_ message: T, memberId: String, chatRoomId: String, messageId: String)
    func updateMessageInFirebase(message: Encodable, dto: ChatMessageDTO)
}

extension FirebaseClient: SendMessageProtocol {
    public func addMessage<T: Encodable>(_ message: T, memberId: String, chatRoomId: String, messageId: String) {
        do {
            try firebaseReference(.messages)
                .document(memberId).collection(chatRoomId)
                .document(messageId)
                .setData(from: message)
        } catch {
            fatalError("Error saving message to firebase: \(error.localizedDescription)")
        }
    }
    
    public func updateMessageInFirebase(message: Encodable, dto: ChatMessageDTO) {
        for userId in dto.memberIds {
            firebaseReference(.messages).document(userId).collection(dto.chatRoomId).document(dto.messageId).updateData(dto.status)
        }
    }
}
