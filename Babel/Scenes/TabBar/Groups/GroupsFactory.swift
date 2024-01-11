import UIKit

enum GroupsFactory {
    static func make() -> UIViewController {
        let worker = GroupsWorker()
        let router = GroupsRouter()
        let presenter = GroupsPresenter(router: router)
        let interactor = GroupsInteractor(worker: worker, presenter: presenter)
        let viewController = GroupsViewController(interactor: interactor)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
