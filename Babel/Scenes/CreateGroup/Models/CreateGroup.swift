import UIKit

struct CreateGroupDTO {
    let id = UUID().uuidString
    let name: String
    let description: String?
    let memberIds: [String]
    let avatarImage: UIImage
}
