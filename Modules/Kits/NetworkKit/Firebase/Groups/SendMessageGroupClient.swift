public protocol SendMessageGroupProtocol {
    func addMessageGroup<T: Encodable>(_ message: T, memberId: String, chatRoomId: String, messageId: String)
    func updateMessageInFirebase(message: Encodable, dto: ChatMessageDTO)
}

extension FirebaseClient: SendMessageGroupProtocol {
    public func addMessageGroup<T: Encodable>(_ message: T, memberId: String, chatRoomId: String, messageId: String) {
        do {
            try firebaseReference(.messages)
                .document(memberId).collection(chatRoomId)
                .document(messageId)
                .setData(from: message)
        } catch {
            fatalError("Error saving message to firebase: \(error.localizedDescription)")
        }
    }
}
