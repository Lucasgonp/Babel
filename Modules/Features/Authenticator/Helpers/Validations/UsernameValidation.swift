import DesignKit

struct UsernameValidation: Validation {
    func run(_ text: String) -> ValidationResult {
        if text.isEmpty {
            return .error(Strings.Error.Field.usernameEmpty.localized())
        }
        if text.count < 3 {
            return .error(Strings.Error.Field.usernameShort.localized())
        }
        
        return .success
    }
}
