import UIKit

enum OpenAIFactory {
    static func make() -> UIViewController {
        let worker = OpenAIWorker()
        let router = OpenAIRouter()
        let presenter = OpenAIPresenter(router: router)
        let interactor = OpenAIInteractor(worker: worker, presenter: presenter)
        let viewController = OpenAIViewController(interactor: interactor)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
