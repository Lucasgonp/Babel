import UIKit

enum LoginAction {
    case finishLogin
}

protocol LoginRouting: AnyObject {
    func perform(action: LoginAction)
}

final class LoginRouter {
    weak var viewController: UIViewController?
    private var completion: (() -> Void)?
    
    init(completion: (() -> Void)?) {
        self.completion = completion
    }
}

// MARK: - LoginRouting
extension LoginRouter: LoginRouting {
    func perform(action: LoginAction) {
        if case .finishLogin = action {
            viewController?.dismiss(animated: true, completion: { [weak self] in
                self?.completion?()
            })
        }
    }
}
