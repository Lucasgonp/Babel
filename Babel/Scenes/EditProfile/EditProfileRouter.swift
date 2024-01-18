import UIKit

enum EditProfileAction {
    case editBio
}

protocol EditProfileRouterProtocol: AnyObject {
    func perform(action: EditProfileAction)
}

final class EditProfileRouter {
    weak var viewController: UIViewController?
}

// MARK: - EditProfileRouterProtocol
extension EditProfileRouter: EditProfileRouterProtocol {
    func perform(action: EditProfileAction) {
        if case .editBio = action {
            let editBio = EditBioFactory.make()
            viewController?.navigationController?.pushViewController(editBio, animated: true)
        }
    }
}
