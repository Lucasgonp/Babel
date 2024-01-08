import StorageKit

public protocol FetchMessageProtocol {
    func getOldChats<T: Decodable>(documentId: String, collectionId: String, completion: @escaping (Result<[T], FirebaseError>) -> Void)
    func getRecentChatsFrom<T: Decodable>(chatRoomId: String, completion: @escaping (_ recents: [T]) -> Void)
}

extension FirebaseClient: FetchMessageProtocol {
    public func getOldChats<T: Decodable>(documentId: String, collectionId: String, completion: @escaping (Result<[T], FirebaseError>) -> Void) {
        firebaseReference(.messages).document(documentId).collection(collectionId).getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                return completion(.failure(.noDocumentFound))
            }
            
            let oldMessages = documents.compactMap({ try? $0.data(as: T.self) })
            completion(.success(oldMessages))
        }
    }
    
    public func getRecentChatsFrom<T: Decodable>(chatRoomId: String, completion: @escaping (_ recents: [T]) -> Void) {
        firebaseReference(.recent).whereField(StorageKey.chatRoomId.rawValue, isEqualTo: chatRoomId).getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                return
            }
            
            let recents = documents.compactMap({ try? $0.data(as: T.self) })
            completion(recents)
        }
    }
}
