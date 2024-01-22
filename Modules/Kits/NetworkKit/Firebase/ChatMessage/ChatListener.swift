public protocol ChatListenerProtocol {
    func listenForNewChats<T: Decodable>(documentId: String, collectionId: String, lastMessageDate: Date, completion: @escaping (Result<T, FirebaseError>) -> Void)
    func listenForReadStatusChange<T: Decodable>(_ documentId: String, collectionId: String, completion: @escaping (T) -> Void)
    func createTypingObserver(chatRoomId: String, currentUserId: String, completion: @escaping (_ isTyping: Bool) -> Void)
    func removeListeners()
}

extension FirebaseClient: ChatListenerProtocol {
    public func listenForNewChats<T: Decodable>(documentId: String, collectionId: String, lastMessageDate: Date, completion: @escaping (Result<T, FirebaseError>) -> Void) {
        newChatListener = firebaseReference(.messages).document(documentId).collection(collectionId).whereField(kDATE, isGreaterThan: lastMessageDate).addSnapshotListener { querySnapshot, error in
            guard let querySnapshot else {
                return completion(.failure(.noDocumentFound))
            }
            
            for change in querySnapshot.documentChanges {
                if change.type == .added {
                    let result = Result {
                        try? change.document.data(as: T.self)
                    }
                    
                    switch result {
                    case let .success(message):
                        if let message {
                            completion(.success(message))
                        } else {
                            print("document doesnt exist")
                        }
                    case let .failure(error):
                        print("error listening for new chats: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    public func listenForReadStatusChange<T: Decodable>(_ documentId: String, collectionId: String, completion: @escaping (T) -> Void) {
        updatedChatListener = firebaseReference(.messages).document(documentId).collection(collectionId).addSnapshotListener({ querySnapshot, error in
            guard let querySnapshot else {
                return
            }
            
            for change in querySnapshot.documentChanges {
                if change.type == .modified {
                    let result = Result {
                        try? change.document.data(as: T.self)
                    }
                    
                    switch result {
                    case let .success(message):
                        if let message {
                            completion(message)
                        } else {
                            print("document doesnt exist")
                        }
                    case let .failure(error):
                        print("error listening for update chat: \(error.localizedDescription)")
                    }
                }
            }
        })
    }
    
    public func removeListeners() {
        typingListener?.remove()
        newChatListener?.remove()
        updatedChatListener?.remove()
        chatBotListener?.remove()
    }
}
