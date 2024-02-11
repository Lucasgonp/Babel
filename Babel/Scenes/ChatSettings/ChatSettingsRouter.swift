import UIKit

protocol ChatSettingsRouterProtocol: AnyObject {
    func changeWallpaper()
}

final class ChatSettingsRouter {
    weak var viewController: UIViewController?
}

extension ChatSettingsRouter: ChatSettingsRouterProtocol {
    func changeWallpaper() {
        let changeWallpaperViewController = ChangeWallpaperViewController()
        viewController?.navigationController?.pushViewController(changeWallpaperViewController, animated: true)
    }
}
