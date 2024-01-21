import UIKit
import DesignKit
import StorageKit

final class ChatBotHelper {
    static let shared = ChatBotHelper()
    
    private var currentUser: User {
        UserSafe.shared.user
    }
    
    enum Images {
        static let chatBotIcon = Icon.marvin.image.withRenderingMode(.alwaysOriginal)
        static let imageGeneratorIcon = UIImage(systemName: "theatermask.and.paintbrush")!.withRenderingMode(.alwaysTemplate)
    }
    
    private init() {}
    
    func createChatRoomId() -> String {
        "CHATBOTROOM=\(currentUser.id)"
    }
    
    func createImageGeneratorRoomId() -> String {
        "IMAGEGENERATORROOM=\(currentUser.id)"
    }
}
