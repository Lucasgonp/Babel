import UIKit
import Firebase
import FirebaseFirestoreSwift

public protocol FirebaseMessageProtocol {
    func addMessage<T: Encodable>(_ message: T, memberId: String, chatRoomId: String, messageId: String)
}

extension FirebaseClient: FirebaseMessageProtocol {
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
