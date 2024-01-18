import UIKit

enum EditBioAction {
    // template
}

protocol EditBioRouterProtocol: AnyObject {
    func perform(action: EditBioAction)
}

final class EditBioRouter {
    weak var viewController: UIViewController?
}

// MARK: - EditBioRouterProtocol
extension EditBioRouter: EditBioRouterProtocol {
    func perform(action: EditBioAction) {
        // template
    }
}
