import FirebaseAuth
import FirebaseFirestore

public struct FirebaseManager {
    public static let shared = FirebaseManager()
    
    public let auth = Auth.auth()
    public let firestore = Firestore.firestore()
    
    private init() {}
}
