import UIKit

protocol EditProfilePresenterProtocol: AnyObject {
    func updateEditProfile()
    func updateAvatarImage(_ image: UIImage)
    func displayErrorMessage(message: String)
    func didNextStep(action: EditProfileAction)
}

final class EditProfilePresenter {
    private let router: EditProfileRouterProtocol
    weak var viewController: EditProfileDisplaying?

    init(router: EditProfileRouterProtocol) {
        self.router = router
    }
}

extension EditProfilePresenter: EditProfilePresenterProtocol {    
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
