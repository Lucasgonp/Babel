public enum AuthError: LocalizedError {
    case genericError
    case custom(Error)
    
    public var errorDescription: String? {
        switch self {
        case .genericError:
            return "Something went wrong, please try again"
        case .custom(let error):
            return error.localizedDescription
        }
    }
}
