public protocol ChatTypingProtocol {
    func createTypingObserver(chatRoomId: String, currentUserId: String, completion: @escaping (_ isTyping: Bool) -> Void)
    func saveTypingCounter(isTyping: Bool, chatRoomId: String, currentUserId: String)
}

extension FirebaseClient: ChatTypingProtocol {
    public func createTypingObserver(chatRoomId: String, currentUserId: String, completion: @escaping (_ isTyping: Bool) -> Void) {
        typingListener = firebaseReference(.typing).document(chatRoomId).addSnapshotListener({ [weak self] snapshot, error in
            guard let snapshot else { return }
            
            if snapshot.exists {
                snapshot.data()?.forEach({
                    if $0.key != currentUserId {
                        completion($0.value as! Bool)
                    }
                })
            } else {
                self?.firebaseReference(.typing).document(chatRoomId).setData([currentUserId: false])
            }
        })
    }
    
    public func saveTypingCounter(isTyping: Bool, chatRoomId: String, currentUserId: String) {
        firebaseReference(.typing).document(chatRoomId).setData([currentUserId: isTyping])
    }
}
