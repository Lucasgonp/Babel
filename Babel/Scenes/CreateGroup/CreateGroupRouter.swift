import UIKit

enum CreateGroupAction {
    case finishGroupCreation
}

protocol CreateGroupRouting: AnyObject {
    func perform(action: CreateGroupAction)
}

final class CreateGroupRouter {
    var completion: (() -> Void)?
    
    weak var viewController: UIViewController?
}

// MARK: - CreateGroupRouting
extension CreateGroupRouter: CreateGroupRouting {
    func perform(action: CreateGroupAction) {
        if case .finishGroupCreation = action {
            viewController?.navigationController?.popViewController { [weak self] in
                self?.completion?()
            }
        }
    }
}
