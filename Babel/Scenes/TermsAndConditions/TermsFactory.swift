import UIKit

enum TermsFactory {
    static func make() -> UIViewController {
        let service = TermsService()
        let router = TermsRouter()
        let presenter = TermsPresenter(router: router)
        let interactor = TermsInteractor(service: service, presenter: presenter)
        let viewController = TermsViewController(interactor: interactor)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
