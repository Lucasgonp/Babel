import UIKit
import Firebase
import Authenticator

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        
        // Push notifications
        Messaging.messaging().delegate = self
        requestPushNotifications()
        application.registerForRemoteNotifications()
        
        return true
    }
    
    //MARK: Deeplink
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
              let host = components.host else {
            print("invalid url: \(url.absoluteString)")
            return false
        }
        
        guard let deeplink = DeeplinkManager.Deeplink(rawValue: host) else {
            print("deeplink not found: \(host)")
            return false
        }
        
        DeeplinkManager.handleDeeplink(deeplink)
        return true
    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        if notification.request.content.userInfo["ViewType"] as! String == "ShowNotificationView" {
//         // Then you can implement your functionaliton here according to the need.
//        }
//    }
    
    //MARK: Remote notifications
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(UIBackgroundFetchResult.newData)
        
        //TO DEBUG:
        /*
        guard let arrAPS = userInfo["aps"] as? [String: Any] else { return }
            if application.applicationState == .active{
                guard let arrAlert = arrAPS["alert"] as? [String:Any] else { return }

                let strTitle:String = arrAlert["title"] as? String ?? ""
                let strBody:String = arrAlert["body"] as? String ?? ""

                let alert = UIAlertController(title: strTitle, message: strBody, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                    print("OK Action")
                })
                let topController = UIApplication.shared.topViewController()
                topController?.present(alert, animated: true)
            } else {
                guard let arrNotification = arrAPS["notification"] as? [String:Any] else { return }
                guard let arrAlert = arrNotification["alert"] as? [String:Any] else { return }

                let strTitle:String = arrAlert["title"] as? String ?? ""
                print("Title --", strTitle)
                let strBody:String = arrAlert["body"] as? String ?? ""
                print("Body --", strBody)
            }
         */
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("unable to register for remote notifications: \(error.localizedDescription)")
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken else { return }
        updateUserPushId(newPushId: fcmToken)
    }
}

private extension AppDelegate {
    func requestPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _,_ in })
    }
    
    func updateUserPushId(newPushId: String) {
        if var user = AccountInfo.shared.user {
            user.pushId = newPushId
            AuthManager.shared.saveUserToFirestore(user) { error in
                if let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
