import FirebaseFirestore

public class FirebaseClient {
    public static var shared = FirebaseClient()
    
    // MessagesClient
    var newChatListener: ListenerRegistration?
    var updatedChatListener: ListenerRegistration?
    
    // TypingClient
    var typingListener: ListenerRegistration?
    
    // GroupListenner
    weak var groupsListenner: ListenerRegistration?
    
    private let firestore: Firestore = .firestore()
    
    private init() {}
}

extension FirebaseClient {
    public func firebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
        return firestore.collection(collectionReference.rawValue)
    }
    
    public func saveRecent<T: Codable>(id: String, recentChat: T) {
        do {
            try firebaseReference(.recent).document(id).setData(from: recentChat)
        } catch {
            print("erro saving recent chat", error.localizedDescription)
        }
    }
    
    public func removeListeners() {
        groupsListenner?.remove()
    }
}
