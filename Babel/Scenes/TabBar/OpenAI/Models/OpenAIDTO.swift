import UIKit

struct OpenAIDTO {
    let name: String
    let bio: String
    let avatar: UIImage
    let action: (() -> Void)?
}
