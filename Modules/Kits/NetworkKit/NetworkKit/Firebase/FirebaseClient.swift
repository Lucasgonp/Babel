import FirebaseFirestore

public final class FirebaseClient {
    public static var shared = FirebaseClient()
    
    private let firestore: Firestore = .firestore()
    
    private init() {}
}

extension FirebaseClient {
    public func firebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
        return firestore.collection(collectionReference.rawValue)
    }
}
