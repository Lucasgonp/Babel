import UIKit
import Foundation
import NetworkKit

final class PushNotificationManager {
    static let shared = PushNotificationManager()
    
    private var keyServerFirebase: String {
        RemoteConfigManager.shared.keyServerFirebase
    }
    
    private let client: UsersClientProtocol
    
    private init(client: UsersClientProtocol = FirebaseClient.shared) {
        self.client = client
    }
    
    func sendPushNotificationToUser(usersIds: [String], body: String, chatRoomId: String) {
        sendPushNotificationTo(usersIds: usersIds, body: body, chatRoomId: chatRoomId, groupName: nil)
    }
    
    func sendPushNotificationToGroup(usersIds: [String], body: String, chatRoomId: String, groupName: String) {
        sendPushNotificationTo(usersIds: usersIds, body: body, chatRoomId: chatRoomId, groupName: groupName)
    }
    
    func resetNotificationBadge() {
        if #available(iOS 16.0, *) {
            UNUserNotificationCenter.current().setBadgeCount(0)
        } else {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
    
    private func sendMessageToUser(to token: String, title: String, body: String, chatRoomId: String) {
        print("token is ...", token)
        let urlString = "https://fcm.googleapis.com/fcm/send"
        
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = [
            "to" : token,
            "notification" : [
                "title" : title,
                "body" : body,
                "badge" : "1",
                "sound" : "default"
            ]
        ]
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key= \(keyServerFirebase)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if let error {
                print("Error push notification: \(error.localizedDescription)")
            }
        }.resume()
    }
}

private extension PushNotificationManager {
    func sendPushNotificationTo(usersIds: [String], body: String, chatRoomId: String, groupName: String?) {
        print("Sending push to user ", usersIds)
        
        DispatchQueue.global().async {
            self.client.downloadUsers(withIds: usersIds) { [weak self] (result: (Result<[User], FirebaseError>)) in
                switch result {
                case let .success(users):
                    for user in users {
                        let title = groupName != nil ? groupName! : AccountInfo.shared.user?.name ?? "User"
                        self?.sendMessageToUser(to: user.pushId, title: title, body: body, chatRoomId: chatRoomId)
                    }
                case let .failure(error):
                    print("error: \(error.localizedDescription)")
                }
            }
        }
    }
}
