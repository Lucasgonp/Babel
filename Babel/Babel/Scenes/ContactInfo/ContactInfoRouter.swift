import UIKit

enum ContactInfoAction {
    // template
}

protocol ContactInfoRouting: AnyObject {
    func perform(action: ContactInfoAction)
}

final class ContactInfoRouter {
    weak var viewController: UIViewController?
}

// MARK: - ContactInfoRouting
extension ContactInfoRouter: ContactInfoRouting {
    func perform(action: ContactInfoAction) {
        // template
    }
}
