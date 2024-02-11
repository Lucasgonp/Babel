import UIKit

enum ChatSettingsFactory {
    static func make() -> UIViewController {
        let router = ChatSettingsRouter()
        let viewController = ChatSettingsViewController(router: router)
        router.viewController = viewController

        return viewController
    }
}
