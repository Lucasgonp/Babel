import UIKit

public class TextFieldInput: UITextField {
    func render(_ theme: TextFieldTheme) {
        let dto = theme.dto
        placeholder = dto.placeholder
        keyboardType = dto.keyboardType
        isSecureTextEntry = dto.isSecureTextEntry
        autocorrectionType = dto.autocorrectionType
        autocapitalizationType = dto.autocapitalizationType
        
        addPadding(.both(8))
        
        reloadInputViews()
    }
}
