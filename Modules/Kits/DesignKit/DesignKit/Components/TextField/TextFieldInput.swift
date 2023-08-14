import UIKit

public class TextFieldInput: UITextField {
    func render(_ theme: TextFieldTheme) {
        let dto = theme.dto
        placeholder = dto.placeholder
        keyboardType = dto.keyboardType
        isSecureTextEntry = dto.isSecureTextEntry
        
        addPadding(.both(8))
    }
}
