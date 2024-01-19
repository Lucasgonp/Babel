import UIKit

enum SystemSettingsFactory {
    static func make() -> UIViewController {
        let worker = SystemSettingsWorker()
        let router = SystemSettingsRouter()
        let presenter = SystemSettingsPresenter(router: router)
        let interactor = SystemSettingsInteractor(worker: worker, presenter: presenter)
        let viewController = SystemSettingsViewController(interactor: interactor)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
