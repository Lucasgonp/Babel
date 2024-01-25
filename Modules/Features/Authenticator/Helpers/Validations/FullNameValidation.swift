import DesignKit

public struct FullNameValidation: Validation {
    public func run(_ text: String) -> ValidationResult {
        if text.isEmpty {
            return .error(Strings.Error.Field.fullnameEmpty.localized())
        }
        if text.count < 3 {
            return .error(Strings.Error.Field.fullNameShort.localized())
        }
        return .success
    }
    
    public init() { }
}
