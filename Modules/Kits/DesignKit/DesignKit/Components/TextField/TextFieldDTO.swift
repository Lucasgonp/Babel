import UIKit

public struct TextFieldDTO {
    let placeholder: String
    let hint: String?
    let keyboardType: UIKeyboardType
    let validations: [Validation]
    let isSecureTextEntry: Bool
    let isFillFieldRequired: Bool
    let border: Border?
    
    public init(
        placeholder: String,
        hint: String?,
        keyboardType: UIKeyboardType = .default,
        validations: [Validation] = [],
        isSecureTextEntry: Bool,
        isFillFieldRequired: Bool,
        border: Border? = nil
    ) {
        self.placeholder = placeholder
        self.hint = hint
        self.keyboardType = keyboardType
        self.validations = validations
        self.isSecureTextEntry = isSecureTextEntry
        self.isFillFieldRequired = isFillFieldRequired
        self.border = border
    }
}

public extension TextFieldDTO {
    struct Border {
        let cornerRadius: CGFloat
        let borderWidth: CGFloat
        let borderColor: Color
    }
}
