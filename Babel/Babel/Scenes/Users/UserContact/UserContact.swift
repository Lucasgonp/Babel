import UIKit

struct UserContact: Hashable, Comparable {
    let name: String
    let about: String
    let image: UIImage?
    
    static func < (lhs: UserContact, rhs: UserContact) -> Bool {
        return lhs.name == rhs.name &&
        lhs.about == rhs.about &&
        lhs.image == rhs.image
    }
}
