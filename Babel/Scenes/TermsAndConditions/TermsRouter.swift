import UIKit

enum TermsAction {
    // template
}

protocol TermsRouterProtocol: AnyObject {
    func perform(action: TermsAction)
}

final class TermsRouter {
    weak var viewController: UIViewController?
}

// MARK: - TermsRouterProtocol
extension TermsRouter: TermsRouterProtocol {
    func perform(action: TermsAction) {
        // template
    }
}
