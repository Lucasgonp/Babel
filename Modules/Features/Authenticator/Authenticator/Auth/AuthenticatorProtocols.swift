import FirebaseAuth

public protocol CheckAuthenticationProtocol {
    func checkAuthentication(completion: @escaping (AuthCheckCredentials?) -> Void)
}

public protocol RegisterProtocol {
    func registerUser(with userRequest: RegisterUserModel, completion: @escaping (Bool, Error?) -> Void)
}

public protocol LoginProtocol {
    func login(with userRequest: LoginUserModel, completion: @escaping ((AuthDataResult?, (any Error)?) -> Void))
}

public protocol LogoutProtocol {
    func logout(completion: @escaping (Error?) -> Void)
}
