import FirebaseAuth
import FirebaseFirestore
import CoreKit

public final class AuthenticatorAdapter {    
    let auth = FirebaseManager.shared.auth
    let firestore = FirebaseManager.shared.firestore
    var listener: AuthStateDidChangeListenerHandle?
    
    public init() {}
}

extension AuthenticatorAdapter {
    public func firebaseReference(_ collectionReference: FCollectionRefence) -> CollectionReference {
        return firestore.collection(collectionReference.rawValue)
    }

}

extension AuthenticatorAdapter {
    func saveUserLocally(_ user: User) {
        StorageManager.shared.saveStorageData(user, key: .currentUser)
    }
}
