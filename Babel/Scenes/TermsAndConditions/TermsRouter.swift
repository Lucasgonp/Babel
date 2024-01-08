import UIKit

enum TermsAction {
    // template
}

protocol TermsRouting: AnyObject {
    func perform(action: TermsAction)
}

final class TermsRouter {
    weak var viewController: UIViewController?
}

// MARK: - TermsRouting
extension TermsRouter: TermsRouting {
    func perform(action: TermsAction) {
        // template
    }
}
