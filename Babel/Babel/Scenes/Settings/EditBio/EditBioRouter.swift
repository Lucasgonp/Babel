import UIKit

enum EditBioAction {
    // template
}

protocol EditBioRouting: AnyObject {
    func perform(action: EditBioAction)
}

final class EditBioRouter {
    weak var viewController: UIViewController?
}

// MARK: - EditBioRouting
extension EditBioRouter: EditBioRouting {
    func perform(action: EditBioAction) {
        // template
    }
}
