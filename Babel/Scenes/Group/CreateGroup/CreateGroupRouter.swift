import UIKit

enum CreateGroupAction {
    case finishGroupCreation
}

protocol CreateGroupRouterProtocol: AnyObject {
    func perform(action: CreateGroupAction)
}

final class CreateGroupRouter {
    var completion: (() -> Void)?
    
    weak var viewController: UIViewController?
}

// MARK: - CreateGroupRouterProtocol
extension CreateGroupRouter: CreateGroupRouterProtocol {
    func perform(action: CreateGroupAction) {
        if case .finishGroupCreation = action {
            viewController?.navigationController?.popViewController { [weak self] _ in
                self?.completion?()
            }
        }
    }
}
