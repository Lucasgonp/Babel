public enum AuthError: LocalizedError {
    case errorRegister
    case errorLogin
    case genericError
    case custom(Error)
    
    public var errorDescription: String? {
        switch self {
        case .genericError:
            return "Something went wrong, please try again"
        case .custom(let error):
            return error.localizedDescription
        case .errorRegister:
            return "Something went wrong during sign in"
        case .errorLogin:
            return "Something went wrong during sign up"
        }
    }
}
