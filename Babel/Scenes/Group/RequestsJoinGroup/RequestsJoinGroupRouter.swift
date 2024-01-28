import UIKit

enum RequestsJoinGroupAction {
    // template
}

protocol RequestsJoinGroupRouterProtocol: AnyObject {
    func perform(action: RequestsJoinGroupAction)
}

final class RequestsJoinGroupRouter {
    weak var viewController: UIViewController?
}

extension RequestsJoinGroupRouter: RequestsJoinGroupRouterProtocol {
    func perform(action: RequestsJoinGroupAction) {
        // template
    }
}
