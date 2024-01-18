import UIKit

enum EditBioFactory {
    static func make() -> UIViewController {
        let authManager = AuthManager.shared
        let service = EditBioWorker(authManager: authManager)
        let router = EditBioRouter()
        let presenter = EditBioPresenter(router: router)
        let interactor = EditBioInteractor(service: service, presenter: presenter)
        let viewController = EditBioViewController(interactor: interactor)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
