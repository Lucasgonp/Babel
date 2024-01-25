public struct User: Codable, Equatable {
    public var id = String()
    public var pushId = String()
    public var avatarLink = String()
    
    public var name: String
    public let email: String
    public let username: String
    public var password: String
    public var status: String
}
