import UIKit
import Authenticator
import DesignKit

enum HomeFactory {
    static func make() -> UIViewController {
        let authManager = AuthManager.shared
        let authPresentation = AuthenticatorPresentation.shared
        let service = HomeWorker(client: authManager)
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
        var tabs = [
            makeChats(),
            makeGroupsTab(),
            makeUsers(),
            makeSettings(delegate: delegate, user: user)
        ]
        if RemoteConfigManager.shared.showTabBots {
            tabs = [
                makeChats(),
                makeGroupsTab(),
                makeOpenAI(),
                makeUsers(),
                makeSettings(delegate: delegate, user: user)
            ]
        }
        return tabs
    }
    
    static func makeSettings(delegate: HomeViewDelegate, user: User) -> HomeTabBarModel {
        let viewController = SettingsFactory.make(delegate: delegate, user: user)
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.navigationBar.prefersLargeTitles = true
        navigation.tabBarItem.title = Strings.TabBar.Settings.title.localized()
        viewController.navigationItem.title = Strings.TabBar.Settings.title.localized()
        let icon = ImageAsset.Image(systemName: "gear")?.withRenderingMode(.alwaysTemplate)
        return HomeTabBarModel(icon: icon, navigation: navigation)
    }
    
    static func makeUsers() -> HomeTabBarModel {
        let viewController = UsersFactory.make()
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.navigationBar.prefersLargeTitles = true
        navigation.tabBarItem.title = Strings.Commons.users.localized()
        viewController.navigationItem.title = Strings.Commons.users.localized()
        let icon = ImageAsset.Image(systemName: "person.2")?.withRenderingMode(.alwaysTemplate)
        return HomeTabBarModel(icon: icon, navigation: navigation)
    }
    
    static func makeOpenAI() -> HomeTabBarModel {
        let viewController = OpenAIFactory.make()
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.navigationBar.prefersLargeTitles = true
        navigation.tabBarItem.title = Strings.TabBar.OpenAI.title.localized()
        viewController.navigationItem.title = Strings.TabBar.OpenAI.title.localized()
        let icon = ImageAsset.Image(systemName: "microbe")?.withRenderingMode(.alwaysTemplate)
        return HomeTabBarModel(icon: icon, navigation: navigation)
    }
    
    static func makeGroupsTab() -> HomeTabBarModel {
        let viewController = GroupsFactory.make()
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.navigationBar.prefersLargeTitles = true
        navigation.tabBarItem.title = Strings.TabBar.Groups.title.localized()
        viewController.navigationItem.title = Strings.TabBar.Groups.title.localized()
        let icon = ImageAsset.Image(systemName: "quote.bubble")?.withRenderingMode(.alwaysTemplate)
        return HomeTabBarModel(icon: icon, navigation: navigation)
    }
    
    static func makeChats() -> HomeTabBarModel {
        let viewController = RecentChatsFactory.make()
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.navigationBar.prefersLargeTitles = true
        navigation.tabBarItem.title = Strings.TabBar.Chats.title.localized()
        viewController.navigationItem.title = Strings.TabBar.Chats.title.localized()
        let icon = ImageAsset.Image(systemName: "message")?.withRenderingMode(.alwaysTemplate)
        return HomeTabBarModel(icon: icon, navigation: navigation)
    }
}
