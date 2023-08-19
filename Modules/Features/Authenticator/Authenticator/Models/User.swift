public struct User: Codable, Equatable {
    var id = String()
    var pushId = String()
    var avatarLink = String()
    
    let name: String
    let email: String
    let username: String
    let password: String
    let status: String
}
