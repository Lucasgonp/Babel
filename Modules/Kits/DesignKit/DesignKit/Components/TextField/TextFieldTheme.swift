import UIKit

public enum TextFieldTheme {
    case standard(
        placeholder: String,
        hint: String? = nil,
        keyboardType: UIKeyboardType = .default,
        validations: [Validation] = [],
        isSecureTextEntry: Bool = false,
        isFillFieldRequired: Bool = true
    )
    case custom(dto: TextFieldDTO)
    
    var dto: TextFieldDTO {
        switch self {
        case let .standard(placeholder, hint, keyboardType, validations, isSecureTextEntry, isFillFieldRequired):
            return TextFieldDTO(
                placeholder: placeholder,
                hint: hint,
                keyboardType: keyboardType,
                validations: validations,
                isSecureTextEntry: isSecureTextEntry,
                isFillFieldRequired: isFillFieldRequired
            )
        case .custom(let dto):
            return dto
        }
    }
    
    var border: TextFieldDTO.Border? {
        switch self {
        case .standard:
            return nil
        case .custom(let dto):
            return dto.border
        }
    }
}
