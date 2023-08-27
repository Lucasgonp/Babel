import UIKit
import StorageKit
import Authenticator

protocol EditProfileInteracting: AnyObject {
    func getUpdatedUser()
    func saveUserToFirebase(user: User)
    func updateAvatarImage(_ image: UIImage)
    func didTapChangeBio()
}

final class EditProfileInteractor {
    private let service: EditProfileServicing
    private let presenter: EditProfilePresenting
    private var currentUser: User
    
    init(
        service: EditProfileServicing,
        presenter: EditProfilePresenting,
        currentUser: User
    ) {
        self.service = service
        self.presenter = presenter
        self.currentUser = currentUser
    }
}

// MARK: - EditProfileInteracting
extension EditProfileInteractor: EditProfileInteracting {
    func getUpdatedUser() {
        service.checkAuthentication { [weak self] credentials in
            if let credentials, credentials.user != self?.currentUser {
                self?.currentUser = credentials.user
                self?.presenter.updateEditProfile()
            }
        }
    }
    
    func saveUserToFirebase(user: User) {
        currentUser = user
        service.saveUserToFirebase(user: user) { [weak self] error in
            guard let self else {
                return
            }
            if let error {
                self.presenter.displayErrorMessage(message: error.localizedDescription)
            } else {
                self.presenter.updateEditProfile()
            }
        }
    }
    
    func updateAvatarImage(_ image: UIImage) {
        let directory = "Avatars/" + "_\(currentUser.id)" + ".jpg"
        service.updateAvatarImage(image, directory: directory) { [weak self] avatarLink in
            guard let self else {
                return
            }
            if let avatarLink {
                self.currentUser.avatarLink = avatarLink
                self.service.saveUserToFirebase(user: self.currentUser) { [weak self] error in
                    guard let self else {
                        return
                    }
                    if let error {
                        self.presenter.displayErrorMessage(message: error.localizedDescription)
                    } else {
                        let imageData = image.jpegData(compressionQuality: 1.0) as? NSData ?? NSData()
                        StorageManager.shared.saveFileLocally(fileData: imageData, fileName: self.currentUser.id)
                        self.presenter.updateAvatarImage(image)
                    }
                }
            }
        }
    }
    
    func didTapChangeBio() {
        presenter.didNextStep(action: .editBio)
    }
}
