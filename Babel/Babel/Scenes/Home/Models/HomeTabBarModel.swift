import UIKit
import DesignKit
import Authenticator

struct HomeTabBarModel {
    let icon: UIImage?
    let navigation: UINavigationController
}

struct HomeTabBarFactory {    
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
        navigation.tabBarItem.title = "Settings"
        navigation.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.title = "Settings"
        let icon = ImageAsset.Image(systemName: "gear")?.withRenderingMode(.alwaysTemplate)
        return HomeTabBarModel(icon: icon, navigation: navigation)
    }
    
    static func makeUsers() -> HomeTabBarModel {
        let viewController = UsersFactory.make()
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.title = "Users"
        let icon = ImageAsset.Image(systemName: "person.2")?.withRenderingMode(.alwaysTemplate)
        return HomeTabBarModel(icon: icon, navigation: navigation)
    }
    
    static func makeChannels() -> HomeTabBarModel {
        let viewController = ChannelsFactory.make()
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.title = "Channels"
        let icon = ImageAsset.Image(systemName: "quote.bubble")?.withRenderingMode(.alwaysTemplate)
        return HomeTabBarModel(icon: icon, navigation: navigation)
    }
    
    static func makeChats() -> HomeTabBarModel {
        let viewController = ChatsFactory.make()
        let navigation = UINavigationController(rootViewController: viewController)
        navigation.title = "Chats"
        let icon = ImageAsset.Image(systemName: "message")?.withRenderingMode(.alwaysTemplate)
        return HomeTabBarModel(icon: icon, navigation: navigation)
    }
}
