public struct RegisterUserRequestModel: Codable, Equatable {
    let fullName: String
    let email: String
    let username: String
    let password: String
}
