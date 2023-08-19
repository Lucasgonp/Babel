import UIKit

public struct AlertViewModel {
    let title: String
    let message: String
    let firstButtonTitle: String
    let secondButtonTitle: String
    let textFieldPlaceholder: String?
    let textFieldKeyboardType: UIKeyboardType?
    
    public var firstButtonAction: ((String?) -> Void)?
    public var secondButtonAction: ((String?) -> Void)?
    
    public init(
        title: String,
        message: String,
        firstButtonTitle: String,
        secondButtonTitle: String,
        textFieldPlaceholder: String? = nil,
        textFieldKeyboardType: UIKeyboardType? = .default
    ) {
        self.title = title
        self.message = message
        self.firstButtonTitle = firstButtonTitle
        self.secondButtonTitle = secondButtonTitle
        self.textFieldPlaceholder = textFieldPlaceholder
        self.textFieldKeyboardType = textFieldKeyboardType
    }
}
