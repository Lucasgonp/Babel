import UIKit

struct CreateGroupDTO {
    let id = UUID().uuidString
    let name: String
    let description: String?
    let members: [User]
    let avatarImage: UIImage
}
