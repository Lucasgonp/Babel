import UIKit

enum ContactInfoFactory {
    static func make(contactInfo: User) -> UIViewController {
        let service = ContactInfoService()
        let router = ContactInfoRouter()
        let presenter = ContactInfoPresenter(router: router)
        let interactor = ContactInfoInteractor(service: service, presenter: presenter, contactInfo: contactInfo)
        let viewController = ContactInfoViewController(interactor: interactor)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
