import FirebaseFirestore

public class FirebaseClient {
    public static var shared = FirebaseClient()
    
    // MessagesClient
    weak var newChatListener: ListenerRegistration?
    weak var updatedChatListener: ListenerRegistration?
    weak var chatBotListener: ListenerRegistration?
    
    // TypingClient
    weak var typingListener: ListenerRegistration?
    
    // GroupListenner
    weak var groupsListenner: ListenerRegistration?
    weak var groupInfoListenner: ListenerRegistration?
    
    private let firestore: Firestore = .firestore()
    
    private init() {}
}

extension FirebaseClient {
    public func firebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
        return firestore.collection(collectionReference.rawValue)
    }
    
    public func saveRecent<T: Codable>(id: String, recentChat: T) {
        do {
            // Aqui que ta o problema
            try firebaseReference(.recent).document(id).setData(from: recentChat)
        } catch {
            print("erro saving recent chat", error.localizedDescription)
        }
    }
    
    public func removeListeners() {
        typingListener?.remove()
        newChatListener?.remove()
        updatedChatListener?.remove()
        chatBotListener?.remove()
        groupsListenner?.remove()
        groupInfoListenner?.remove()
    }
}
