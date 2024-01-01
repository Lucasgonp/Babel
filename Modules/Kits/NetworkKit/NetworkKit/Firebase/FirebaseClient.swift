import FirebaseFirestore

public class FirebaseClient {
    public static var shared = FirebaseClient()
    
    // MessagesClient
    weak var newChatListener: ListenerRegistration?
    weak var updatedChatListener: ListenerRegistration?
    
    // TypingClient
    weak var typingListener: ListenerRegistration?
    
    private let firestore: Firestore = .firestore()
    
    private init() {}
}

extension FirebaseClient {
    public func firebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
        return firestore.collection(collectionReference.rawValue)
    }
    
    public func saveRecentChat<T: Codable>(id: String, recentChat: T) {
        do {
            try firebaseReference(.recent).document(id).setData(from: recentChat)
        } catch {
            print("erro saving recent chat", error.localizedDescription)
        }
    }
}
