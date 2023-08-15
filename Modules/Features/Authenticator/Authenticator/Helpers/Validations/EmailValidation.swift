import DesignKit

struct EmailValidation: Validation {
    func run(_ text: String) -> ValidationResult {
        if text.isEmpty {
            return .error(Strings.Error.Field.emailEmpty)
        }
        
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let range = NSRange(location: 0, length: text.utf16.count)
        let regex = try? NSRegularExpression(pattern: pattern)
        let firstMatch = regex?.firstMatch(in: text, range: range)
        if firstMatch != nil {
            return .success
        } else {
            return .error(Strings.Error.Field.emailInvalid)
        }
    }
}
