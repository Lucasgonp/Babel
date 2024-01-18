import UIKit
import NetworkKit

enum RecentChatsFactory {
    static func make() -> UIViewController {
        let service = RecentChatsWorker(client: FirebaseClient.shared)
        let router = RecentChatsRouter()
        let presenter = RecentChatsPresenter(router: router)
        let interactor = RecentChatsInteractor(service: service, presenter: presenter)
        let viewController = RecentChatsViewController(interactor: interactor)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
