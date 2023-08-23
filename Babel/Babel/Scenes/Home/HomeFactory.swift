import NetworkKit
import UIKit
import Authenticator
import DesignKit

enum HomeFactory {
    static func make() -> UIViewController {
        let authManager = AuthManager.shared
        let authPresentation = AuthenticatorPresentation.shared
        let service = HomeService(client: NetworkManager.session, authManager: authManager)
        let router = HomeRouter(authPresentation: authPresentation)
        let presenter = HomePresenter(router: router)
        let interactor = HomeInteractor(service: service, presenter: presenter)
        let viewController = HomeViewController(interactor: interactor)

        router.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}

enum HomeTabBarFactory {
    static func makeTabs(delegate: HomeViewDelegate,for user: User) -> [HomeTabBarModel] {
        return [
            makeChats(),
            makeChannels(),
            makeUsers(),
            makeSettings(delegate: delegate, for: user)
        ]
    }
    
    static func makeSettings(delegate: HomeViewDelegate, for user: User) -> HomeTabBarModel {
        let viewController = SettingsFactory.make(delegate: delegate, for: user)
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.navigationBar.prefersLargeTitles = true
        navigation.tabBarItem.title = Strings.TabBar.Settings.title
        viewController.navigationItem.title = Strings.TabBar.Settings.title
        let icon = ImageAsset.Image(systemName: "gear")?.withRenderingMode(.alwaysTemplate)
        return HomeTabBarModel(icon: icon, navigation: navigation)
    }
    
    static func makeUsers() -> HomeTabBarModel {
        let viewController = UsersFactory.make()
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.navigationBar.prefersLargeTitles = true
        navigation.tabBarItem.title = Strings.TabBar.Users.title
        viewController.navigationItem.title = Strings.TabBar.Users.title
        let icon = ImageAsset.Image(systemName: "person.2")?.withRenderingMode(.alwaysTemplate)
        return HomeTabBarModel(icon: icon, navigation: navigation)
    }
    
    static func makeChannels() -> HomeTabBarModel {
        let viewController = ChannelsFactory.make()
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.navigationBar.prefersLargeTitles = true
        navigation.tabBarItem.title = Strings.TabBar.Channels.title
        viewController.navigationItem.title = Strings.TabBar.Channels.title
        let icon = ImageAsset.Image(systemName: "quote.bubble")?.withRenderingMode(.alwaysTemplate)
        return HomeTabBarModel(icon: icon, navigation: navigation)
    }
    
    static func makeChats() -> HomeTabBarModel {
        let viewController = ChatsFactory.make()
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.navigationBar.prefersLargeTitles = true
        navigation.tabBarItem.title = Strings.TabBar.Chats.title
        viewController.navigationItem.title = Strings.TabBar.Chats.title
        let icon = ImageAsset.Image(systemName: "message")?.withRenderingMode(.alwaysTemplate)
        return HomeTabBarModel(icon: icon, navigation: navigation)
    }
}
