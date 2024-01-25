import UIKit

enum SystemSettingsFactory {
    static func make(delegate: SystemSettingsDelegate?) -> UIViewController {
        let worker = SystemSettingsWorker()
        let router = SystemSettingsRouter()
        let presenter = SystemSettingsPresenter(router: router)
        let interactor = SystemSettingsInteractor(worker: worker, presenter: presenter)
        let viewController = SystemSettingsViewController(interactor: interactor)
        
        viewController.delegate = delegate
        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
