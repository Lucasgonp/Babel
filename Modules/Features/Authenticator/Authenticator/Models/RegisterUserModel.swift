public struct RegisterUserModel: Codable {
    let name: String
    let email: String
    let username: String
    let password: String
    
    public init(name: String, email: String, username: String, password: String) {
        self.name = name
        self.email = email
        self.username = username
        self.password = password
    }
}
