import UIKit

enum ChannelsFactory {
    static func make() -> UIViewController {
        let service = ChannelsService()
        let router = ChannelsRouter()
        let presenter = ChannelsPresenter(router: router)
        let interactor = ChannelsInteractor(service: service, presenter: presenter)
        let viewController = ChannelsViewController(interactor: interactor)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
