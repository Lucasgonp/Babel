import DesignKit

struct FullNameValidation: Validation {
    func run(_ text: String) -> ValidationResult {
        if text.isEmpty {
            return .error(Strings.Error.Field.fullnameEmpty)
        }
        if text.count < 3 {
            return .error(Strings.Error.Field.fullNameShort)
        }
        return .success
    }
}
