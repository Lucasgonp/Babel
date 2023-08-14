import UIKit

enum LoginFactory {
    static func make(completion: (() -> Void)?) -> UIViewController {
        let service = LoginService()
        let router = LoginRouter(completion: completion)
        let presenter = LoginPresenter(router: router)
        let interactor = LoginInteractor(service: service, presenter: presenter)
        let viewController = LoginViewController(interactor: interactor)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
