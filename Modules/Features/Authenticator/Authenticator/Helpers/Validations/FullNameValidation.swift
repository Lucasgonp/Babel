import DesignKit

struct FullNameValidation: Validation {
    func run(_ text: String) -> ValidationResult {
        if text.isEmpty {
            return .error(Strings.Error.Field.fullnameEmpty)
        }
        return .success
    }
}
