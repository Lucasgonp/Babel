import Foundation

public protocol Validation {
    func run(_ text: String) -> ValidationResult
}

public enum ValidationResult: Equatable {
    case none
    case error(String)
    case success

    public var message: String? {
        switch self {
        case .error(let message):
            return message
        default:
            return nil
        }
    }
}
