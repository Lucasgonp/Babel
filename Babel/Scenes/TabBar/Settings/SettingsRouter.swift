import UIKit
import Authenticator

enum SettingsAction {
    case pushEditProfile(user: User)
    case pushTellAFriend
    case pushTermsAndCondition
    case logout
}

protocol SettingsRouting: AnyObject {
    func perform(action: SettingsAction)
}

final class SettingsRouter {
    weak var viewController: UIViewController?
    weak var delegate: HomeViewDelegate?
}

// MARK: - SettingsRouting
extension SettingsRouter: SettingsRouting {
    func perform(action: SettingsAction) {
        switch action {
        case .pushEditProfile(let user):
            pushEditProfile(user: user)
        case .pushTellAFriend:
            pushTellAFriend()
        case .pushTermsAndCondition:
            pushTermsAndCondition()
        case .logout:
            delegate?.logout()
        }
    }
}

private extension SettingsRouter {
    func pushEditProfile(user: User) {
        let controller = EditProfileFactory.make(
            user: user,
            delegate: viewController as? SettingsViewDelegate
        )
        controller.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func pushTellAFriend() {
        let controller = TellAFriendFactory.make()
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func pushTermsAndCondition() {
        let controller = TermsFactory.make()
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }
}
