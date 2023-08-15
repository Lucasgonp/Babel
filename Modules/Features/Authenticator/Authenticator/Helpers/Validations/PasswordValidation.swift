import DesignKit

struct PasswordValidation: Validation {
    func run(_ text: String) -> ValidationResult {
        if text.isEmpty {
            return .error(Strings.Error.Field.passwordEmpty)
        }
        return .success
    }
}
