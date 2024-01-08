import UIKit
import NetworkKit

enum ContactInfoFactory {
    static func make(contactInfo: User, shouldDisplayStartChat: Bool) -> UIViewController {
        let client = FirebaseClient.shared
        let service = ContactInfoService(client: client)
        let router = ContactInfoRouter()
        let presenter = ContactInfoPresenter(router: router)
        let interactor = ContactInfoInteractor(
            service: service,
            presenter: presenter,
            contactUser: contactInfo,
            shouldDisplayStartChat: shouldDisplayStartChat
        )
        let viewController = ContactInfoViewController(interactor: interactor)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
    
    static func make(contactUserId: String, shouldDisplayStartChat: Bool) -> UIViewController {
        let client = FirebaseClient.shared
        let service = ContactInfoService(client: client)
        let router = ContactInfoRouter()
        let presenter = ContactInfoPresenter(router: router)
        let interactor = ContactInfoInteractor(
            service: service,
            presenter: presenter,
            contactUserId: contactUserId,
            shouldDisplayStartChat: shouldDisplayStartChat
        )
        let viewController = ContactInfoViewController(interactor: interactor)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
