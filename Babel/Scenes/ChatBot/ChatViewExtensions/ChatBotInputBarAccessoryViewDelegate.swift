import InputBarAccessoryView

extension ChatBotViewController: InputBarAccessoryViewDelegate {    
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
