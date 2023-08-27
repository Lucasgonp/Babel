import UIKit

public protocol TextFieldDelegate: AnyObject {
    func textFieldDidChange(_ textField: TextFieldInput)
    func textFieldDidBeginEditing(_ textField: TextFieldInput)
    func textFieldDidEndEditing(_ textField: TextFieldInput)
    func textFieldShouldReturn(_ textField: TextFieldInput)
}

public extension TextFieldDelegate {
    func textFieldDidChange(_ textField: TextFieldInput) { }
    func textFieldDidBeginEditing(_ textField: TextFieldInput) { }
    func textFieldDidEndEditing(_ textField: TextFieldInput) { }
    func textFieldShouldReturn(_ textField: TextFieldInput) { }
}
