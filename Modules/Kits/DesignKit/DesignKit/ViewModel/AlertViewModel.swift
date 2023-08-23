import UIKit

public struct AlertButtonViewModel {
    let title: String
    let style: UIAlertAction.Style
    
    public init(title: String, style: UIAlertAction.Style) {
        self.title = title
        self.style = style
    }
}

public struct AlertViewModel {
    let title: String
    let message: String
    let firstButton: AlertButtonViewModel
    let secondButton: AlertButtonViewModel
    let textFieldPlaceholder: String?
    let textFieldKeyboardType: UIKeyboardType?
    
    public var firstButtonAction: ((String?) -> Void)?
    public var secondButtonAction: ((String?) -> Void)?
    
    public init(
        title: String,
        message: String,
        firstButton: AlertButtonViewModel,
        secondButton: AlertButtonViewModel,
        textFieldPlaceholder: String? = nil,
        textFieldKeyboardType: UIKeyboardType? = .default
    ) {
        self.title = title
        self.message = message
        self.firstButton = firstButton
        self.secondButton = secondButton
        self.textFieldPlaceholder = textFieldPlaceholder
        self.textFieldKeyboardType = textFieldKeyboardType
    }
}
