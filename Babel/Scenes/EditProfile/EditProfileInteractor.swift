import UIKit
import StorageKit
import Authenticator

protocol EditProfileInteractorProtocol: AnyObject {
    func getUpdatedUser()
    func saveUserToFirebase(user: User)
    func updateAvatarImage(_ image: UIImage)
    func didTapChangeBio()
}

final class EditProfileInteractor {
    private let service: EditProfileWorkerProtocol
    private let presenter: EditProfilePresenterProtocol
    private var currentUser: User
    
    init(
        service: EditProfileWorkerProtocol,
        presenter: EditProfilePresenterProtocol,
        currentUser: User
    ) {
        self.service = service
        self.presenter = presenter
        self.currentUser = currentUser
    }
}

// MARK: - EditProfileInteractorProtocol
extension EditProfileInteractor: EditProfileInteractorProtocol {
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
        let directory = FileDirectory.avatars.format(currentUser.id)
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
