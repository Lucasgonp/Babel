import DesignKit

struct PasswordValidation: Validation {
    func run(_ text: String) -> ValidationResult {
        if text.isEmpty {
            return .error(Strings.Error.Field.passwordEmpty)
        }
        if text.count <= 3 {
            return .error(Strings.Error.Field.passwordShort)
        }
        return .success
    }
}
