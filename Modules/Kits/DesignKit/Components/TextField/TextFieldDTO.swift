import UIKit

public struct TextFieldDTO {
    let placeholder: String
    let hint: String?
    let isHintAlwaysVisible: Bool
    let keyboardType: UIKeyboardType
    let validations: [Validation]
    let isSecureTextEntry: Bool
    let border: Border?
    let autocorrectionType: UITextAutocorrectionType
    let autocapitalizationType: UITextAutocapitalizationType
    let hasDividorView: Bool
    let hasFeedback: Bool
    let textLength: Int?
    let textContentType: UITextContentType?
    
    public init(
        placeholder: String,
        hint: String?,
        isHintAlwaysVisible: Bool,
        keyboardType: UIKeyboardType = .default,
        validations: [Validation] = [],
        isSecureTextEntry: Bool,
        border: Border? = nil,
        autocorrectionType: UITextAutocorrectionType,
        autocapitalizationType: UITextAutocapitalizationType,
        hasDividorView: Bool,
        hasFeedback: Bool,
        textLength: Int? = nil,
        textContentType: UITextContentType? = nil
    ) {
        self.placeholder = placeholder
        self.hint = hint
        self.isHintAlwaysVisible = isHintAlwaysVisible
        self.keyboardType = keyboardType
        self.validations = validations
        self.isSecureTextEntry = isSecureTextEntry
        self.border = border
        self.autocorrectionType = autocorrectionType
        self.autocapitalizationType = autocapitalizationType
        self.hasDividorView = hasDividorView
        self.hasFeedback = hasFeedback
        self.textLength = textLength
        self.textContentType = textContentType
    }
}

public extension TextFieldDTO {
    struct Border {
        let cornerRadius: CGFloat
        let borderWidth: CGFloat
        let borderColor: Color
    }
}
