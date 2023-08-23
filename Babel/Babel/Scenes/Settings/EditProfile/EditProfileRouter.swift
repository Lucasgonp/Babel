import UIKit

enum EditProfileAction {
    // template
}

protocol EditProfileRouting: AnyObject {
    func perform(action: EditProfileAction)
}

final class EditProfileRouter {
    weak var viewController: UIViewController?
}

// MARK: - EditProfileRouting
extension EditProfileRouter: EditProfileRouting {
    func perform(action: EditProfileAction) {
        // template
    }
}
