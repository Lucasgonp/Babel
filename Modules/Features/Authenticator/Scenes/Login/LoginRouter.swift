import UIKit

enum LoginAction {
    case didLoginSuccess
    case presentSignUp
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
        switch action {
        case .didLoginSuccess:
            viewController?.dismiss(animated: true, completion: { [weak self] in
                self?.completion?()
            })
        case .presentSignUp:
            let register = RegisterFactory.make()
            viewController?.navigationController?.pushViewController(register, animated: true)
        }
    }
}
