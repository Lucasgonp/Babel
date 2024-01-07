import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        setupWindow(scene)
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // TODO: If share live location remove this
        LocationManager.shared.stopUpdating()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // TODO: If share live location remove this
        LocationManager.shared.stopUpdating()
    }
}

private extension SceneDelegate {
    func setupWindow(_ scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let viewController = HomeFactory.make()        
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}
