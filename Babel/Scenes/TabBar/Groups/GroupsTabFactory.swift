import UIKit

enum GroupsTabFactory {
    static func make() -> UIViewController {
        let service = GroupsTabService()
        let router = GroupsTabRouter()
        let presenter = GroupsTabPresenter(router: router)
        let interactor = GroupsTabInteractor(service: service, presenter: presenter)
        let viewController = GroupsTabViewController(interactor: interactor)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
