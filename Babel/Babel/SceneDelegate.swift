import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        setupWindow(scene)
    }
}

private extension SceneDelegate {
    func setupWindow(_ scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let rootViewController = HomeFactory.make()
        let navigation = UINavigationController(rootViewController: rootViewController)
        navigation.modalPresentationStyle = .fullScreen
        
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
}
