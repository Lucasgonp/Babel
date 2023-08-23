import UIKit

enum EditProfileFactory {
    static func make(user: User) -> UIViewController {
        let service = EditProfileService()
        let router = EditProfileRouter()
        let presenter = EditProfilePresenter(router: router)
        let interactor = EditProfileInteractor(service: service, presenter: presenter, user: user)
        let viewController = EditProfileViewController(interactor: interactor)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
