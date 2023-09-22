struct UserContact: Hashable, Comparable {
    let name: String
    let about: String
    let avatarLink: String
    
    static func < (lhs: UserContact, rhs: UserContact) -> Bool {
        return lhs.name == rhs.name &&
        lhs.about == rhs.about &&
        lhs.avatarLink == rhs.avatarLink
    }
}
