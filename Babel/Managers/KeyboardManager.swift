import UIKit

final class KeyboardManager {
    static let shared = KeyboardManager()
    
    private(set) var isKeyboardVisible = false
    
    private init() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func showKeyboard() {
        isKeyboardVisible = true
    }
    
    @objc private func hideKeyboard() {
        isKeyboardVisible = false
    }
}
