import UIKit

enum CreateGroupFactory {
    static func make(completion: (() -> Void)?) -> UIViewController {
        let worker = CreateGroupWorker()
        let router = CreateGroupRouter()
        let presenter = CreateGroupPresenter(router: router)
        let interactor = CreateGroupInteractor(worker: worker, presenter: presenter)
        let viewController = CreateGroupViewController(interactor: interactor)

        router.completion = completion
        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
