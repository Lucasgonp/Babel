import UIKit
import Firebase
import FirebaseFirestoreSwift

public protocol FirebaseMessageProtocol {
    func listenForNewChats<T: Decodable>(documentId: String, collectionId: String, lastMessageDate: Date, completion: @escaping (Result<T, FirebaseError>) -> Void)
    func getOldChats<T: Decodable>(documentId: String, collectionId: String, completion: @escaping (Result<[T], FirebaseError>) -> Void)
    func addMessage<T: Encodable>(_ message: T, memberId: String, chatRoomId: String, messageId: String)
}

extension FirebaseClient: FirebaseMessageProtocol {
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
//        var updatedChatListener: ListenerRegistration?
    }
    
    public func getOldChats<T: Decodable>(documentId: String, collectionId: String, completion: @escaping (Result<[T], FirebaseError>) -> Void) {
        firebaseReference(.messages).document(documentId).collection(collectionId).getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                return completion(.failure(.noDocumentFound))
            }
            
            let oldMessages = documents.compactMap({ try? $0.data(as: T.self) })
            completion(.success(oldMessages))
        }
    }
    
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
}
