public protocol ChatBotProtocol {
    func addMessageBot<T: Encodable>(_ message: T, currentUserId: String, chatRoomId: String, messageId: String)
    func listenForNewChats<T: Decodable>(documentId: String, collectionId: String, lastMessageDate: Date, completion: @escaping (Result<T, FirebaseError>) -> Void)
    func removeListeners()
}

extension FirebaseClient: ChatBotProtocol {
    public func addMessageBot<T: Encodable>(_ message: T, currentUserId: String, chatRoomId: String, messageId: String) {
        do {
            try firebaseReference(.bot)
                .document(currentUserId)
                .collection(chatRoomId)
                .document(messageId)
                .setData(from: message)
        } catch {
            fatalError("Error saving message to firebase: \(error.localizedDescription)")
        }
    }
    
    public func listenForNewChatsBot<T: Decodable>(documentId: String, collectionId: String, lastMessageDate: Date, completion: @escaping (Result<T, FirebaseError>) -> Void) {
//        chatBotListener = firebaseReference(.bot)
//            .document(documentId)
//            .collection(collectionId)
//            .whereField(kDATE, isGreaterThan: lastMessageDate)
//            .addSnapshotListener { querySnapshot, error in
//                guard let querySnapshot else { return completion(.failure(.noDocumentFound)) }
//                
//                for change in querySnapshot.documentChanges {
//                    if change.type == .added {
//                        let result = Result {
//                            try? change.document.data(as: T.self)
//                        }
//                        
//                        switch result {
//                        case let .success(message):
//                            if let message {
//                                completion(.success(message))
//                            } else {
//                                print("document doesnt exist")
//                            }
//                        case let .failure(error):
//                            print("error listening for new chats: \(error.localizedDescription)")
//                        }
//                    }
//                }
//            }
    }
}
