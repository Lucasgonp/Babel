import UIKit

enum EditProfileAction {
    case editBio
}

protocol EditProfileRouting: AnyObject {
    func perform(action: EditProfileAction)
}

final class EditProfileRouter {
    weak var viewController: UIViewController?
}

// MARK: - EditProfileRouting
extension EditProfileRouter: EditProfileRouting {
    func perform(action: EditProfileAction) {
        if case .editBio = action {
            let editBio = EditBioFactory.make()
            viewController?.navigationController?.pushViewController(editBio, animated: true)
        }
    }
}
