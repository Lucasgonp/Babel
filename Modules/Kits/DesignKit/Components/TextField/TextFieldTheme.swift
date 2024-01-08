import UIKit

public enum TextFieldTheme {
    case standard(
        placeholder: String,
        hint: String? = nil,
        isHintAlwaysVisible: Bool = false,
        keyboardType: UIKeyboardType = .default,
        validations: [Validation] = [],
        isSecureTextEntry: Bool = false,
        autocorrectionType: UITextAutocorrectionType = .no,
        autocapitalizationType: UITextAutocapitalizationType = .none,
        hasDividorView: Bool = true,
        textLength: Int? = nil
    )
    case clean(
        placeholder: String,
        hint: String? = nil,
        isHintAlwaysVisible: Bool = false,
        keyboardType: UIKeyboardType = .default,
        autocorrectionType: UITextAutocorrectionType = .no,
        autocapitalizationType: UITextAutocapitalizationType = .none,
        textLength: Int? = nil
    )
    case simple(
        placeholder: String,
        keyboardType: UIKeyboardType = .default,
        autocapitalizationType: UITextAutocapitalizationType = .none,
        textLength: Int? = nil
    )
    case custom(dto: TextFieldDTO)
    
    var dto: TextFieldDTO {
        switch self {
        case let .standard(
            placeholder,
            hint,
            isHintAlwaysVisible,
            keyboardType,
            validations,
            isSecureTextEntry,
            autocorrectionType,
            autocapitalizationType,
            hasDividorView,
            textLength
        ):
            return TextFieldDTO(
                placeholder: placeholder,
                hint: hint,
                isHintAlwaysVisible: isHintAlwaysVisible,
                keyboardType: keyboardType,
                validations: validations,
                isSecureTextEntry: isSecureTextEntry,
                autocorrectionType: autocorrectionType,
                autocapitalizationType: autocapitalizationType,
                hasDividorView: hasDividorView,
                hasFeedback: true,
                textLength: textLength
            )
        case let .clean(
            placeholder,
            hint,
            isHintAlwaysVisible,
            keyboardType,
            autocorrectionType,
            autocapitalizationType,
            textLength
        ):
            return TextFieldDTO(
                placeholder: placeholder,
                hint: hint,
                isHintAlwaysVisible: isHintAlwaysVisible,
                keyboardType: keyboardType,
                isSecureTextEntry: false,
                autocorrectionType: autocorrectionType,
                autocapitalizationType: autocapitalizationType,
                hasDividorView: false,
                hasFeedback: false,
                textLength: textLength
            )
        case let .simple(
            placeholder,
            keyboardType,
            autocapitalizationType,
            textLength
        ):
            return TextFieldDTO(
                placeholder: placeholder,
                hint: nil,
                isHintAlwaysVisible: false,
                keyboardType: keyboardType,
                validations: [],
                isSecureTextEntry: false,
                autocorrectionType: .default,
                autocapitalizationType: autocapitalizationType,
                hasDividorView: false,
                hasFeedback: false,
                textLength: textLength
            )
        case .custom(let dto):
            return dto
        }
    }
    
    var border: TextFieldDTO.Border? {
        switch self {
        case .standard:
            return nil
        case .clean:
            return nil
        case .simple:
            return nil
        case .custom(let dto):
            return dto.border
        }
    }
}
