import UIKit

protocol EditProfilePresenting: AnyObject {
    func updateEditProfile()
    func updateAvatarImage(_ image: UIImage)
    func displayErrorMessage(message: String)
    func didNextStep(action: EditProfileAction)
}

final class EditProfilePresenter {
    private let router: EditProfileRouting
    weak var viewController: EditProfileDisplaying?

    init(router: EditProfileRouting) {
        self.router = router
    }
}

// MARK: - EditProfilePresenting
extension EditProfilePresenter: EditProfilePresenting {    
    func updateEditProfile() {
        viewController?.updateEditProfile()
    }
    
    func updateAvatarImage(_ image: UIImage) {
        viewController?.updateAvatarImage(image)
    }
    
    func displayErrorMessage(message: String) {
        viewController?.displayErrorMessage(message: message)
    }
    
    func didNextStep(action: EditProfileAction) {
        router.perform(action: action)
    }
}
