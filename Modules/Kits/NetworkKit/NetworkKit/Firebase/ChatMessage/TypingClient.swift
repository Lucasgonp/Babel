public protocol FirebaseTypingProtocol {
    func createTypingObserver(chatRoomId: String, completion: @escaping ([String : Any]?) -> Void)
}

extension FirebaseClient: FirebaseTypingProtocol {
    public func createTypingObserver(chatRoomId: String, completion: @escaping ([String : Any]?) -> Void) {
        typingListener = firebaseReference(.typing).document(chatRoomId).addSnapshotListener({ snapshot, error in
            guard let snapshot else { return }
            
            if snapshot.exists {
                completion(snapshot.data())
            }
        })
    }
}
