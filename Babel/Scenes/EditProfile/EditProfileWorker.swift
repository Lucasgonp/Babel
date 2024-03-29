import Authenticator
import StorageKit
import UIKit
import NetworkKit

protocol EditProfileWorkerProtocol {
    func checkAuthentication(completion: @escaping (AuthCheckCredentials?) -> Void)
    func saveUserToFirebase(user: User, completion: @escaping (Error?) -> Void)
    func updateAvatarImage(_ image: UIImage, directory: String, completion: @escaping (String?) -> Void)
}

final class EditProfileWorker {
    typealias AuthDependencies = CheckAuthenticationProtocol &
                                 AuthenticatorSaveUserProtocol
    
    private let authManager: AuthDependencies
    private let client: EditProfileClientProtocol
    
    init(authManager: AuthDependencies, client: EditProfileClientProtocol = FirebaseClient.shared) {
        self.authManager = authManager
        self.client = client
    }
}

extension EditProfileWorker: EditProfileWorkerProtocol {
    func checkAuthentication(completion: @escaping (AuthCheckCredentials?) -> Void) {
        authManager.checkAuthentication(thread: .main, completion: completion)
    }
    
    func saveUserToFirebase(user: User, completion: @escaping (Error?) -> Void) {
        authManager.saveUserToFirestore(user, completion: completion)
    }
    
    func updateAvatarImage(_ image: UIImage, directory: String, completion: @escaping (String?) -> Void) {
        StorageManager.shared.uploadImage(image, directory: directory, callbackThread: .main) { [weak self] documentLink in
            if let documentLink {
                self?.client.updateAvatarsOrigin(currentUserId: UserSafe.shared.user.id, imageLink: documentLink)
            }
            completion(documentLink)
        }
    }
}
