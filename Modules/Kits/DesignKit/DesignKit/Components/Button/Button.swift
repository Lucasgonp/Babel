import UIKit

public class Button: UIButton {
    
    /// Render
    /// - Parameter theme: ButtonTheme
    public func render(_ theme: ButtonTheme) {
        let dto = theme.dto
        makeAttributes(text: dto.title)
        setTitleColor(dto.titleColor.uiColor, for: .normal)
        backgroundColor = dto.backgroundColor.uiColor
        layer.cornerRadius = dto.cornerRadius
    }
    
    /// Return attributed string
    /// - Parameter text: Set Strings with bold attributes
    func makeAttributes(text: String) {
        let boldText = text.slice(from: "**", to: "**") ?? String()
        let clearText = text.replacingOccurrences(of: boldText, with: String()).replacingOccurrences(of: "*", with: String())
        
        let attributedTitle = NSMutableAttributedString(
            string: clearText,
            attributes: [.font: Font.md.uiFont]
        )
        attributedTitle.append(NSAttributedString(
            string: boldText,
            attributes: [.font: Font.md.make(isBold: true)]
        ))
        
        setAttributedTitle(attributedTitle, for: .normal)
    }
}
