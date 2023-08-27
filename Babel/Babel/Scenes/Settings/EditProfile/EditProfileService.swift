import Authenticator
import StorageKit
import UIKit

protocol EditProfileServicing {
    func checkAuthentication(completion: @escaping (AuthCheckCredentials?) -> Void)
    func saveUserToFirebase(user: User, completion: @escaping (Error?) -> Void)
    func updateAvatarImage(_ image: UIImage, directory: String, completion: @escaping (String?) -> Void)
}

final class EditProfileService {
    typealias AuthDependencies = CheckAuthenticationProtocol &
                                 AuthenticatorSaveUserProtocol
    
    private let authManager: AuthDependencies
    private let storage: StorageRemoteUploadImageProtocol
    
    init(authManager: AuthDependencies, storage: StorageRemoteUploadImageProtocol) {
        self.authManager = authManager
        self.storage = storage
    }
}

// MARK: - EditProfileServicing
extension EditProfileService: EditProfileServicing {
    func checkAuthentication(completion: @escaping (AuthCheckCredentials?) -> Void) {
        authManager.checkAuthentication(thread: .main, completion: completion)
    }
    
    func saveUserToFirebase(user: User, completion: @escaping (Error?) -> Void) {
        authManager.saveUserToFirestore(user, thread: .main, completion: completion)
    }
    
    func updateAvatarImage(_ image: UIImage, directory: String, completion: @escaping (String?) -> Void) {
        storage.uploadImage(image, directory: directory, callbackThread: .main, completion: completion)
    }
}
