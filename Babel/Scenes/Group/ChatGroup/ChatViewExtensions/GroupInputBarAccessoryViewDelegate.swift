import InputBarAccessoryView

extension ChatGroupViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        if !text.isEmpty {
            updateTypingObserver()
        }
        
        updateMicButtonStatus(show: text.isEmpty)
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        for component in inputBar.inputTextView.components {
            if let text = component as? String {
                messageSend(text: text)
            }
        }
        
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()
    }
}
