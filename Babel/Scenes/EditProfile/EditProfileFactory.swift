import UIKit

enum EditProfileFactory {
    static func make(user: User, delegate: SettingsViewDelegate?) -> UIViewController {
        let authManager = AuthManager.shared
        let service = EditProfileWorker(authManager: authManager)
        let router = EditProfileRouter()
        let presenter = EditProfilePresenter(router: router)
        let interactor = EditProfileInteractor(service: service, presenter: presenter, currentUser: user)
        let viewController = EditProfileViewController(interactor: interactor)
        
        viewController.delegate = delegate
        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
