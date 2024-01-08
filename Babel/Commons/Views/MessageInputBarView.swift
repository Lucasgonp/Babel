import UIKit
import DesignKit
import InputBarAccessoryView

protocol MessageInputBarDelegate: AnyObject {
    func openAttachActionSheet()
    func audioRecording(_ state: RecordingState)
}

final class MessageInputBarView: InputBarAccessoryView {
    private lazy var micButtonItem: InputBarButtonItem = {
        let micButtonItem = InputBarButtonItem()
        micButtonItem.image = UIImage(systemName: "mic.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30))
        micButtonItem.setSize(CGSize(width: 30, height: 30), animated: false)
        micButtonItem.addGestureRecognizer(shortPressRecognizer)
        micButtonItem.addGestureRecognizer(longPressRecognizer)
        return micButtonItem
    }()
    
    private let trashButtonItem: InputBarButtonItem = {
        let trashButton = InputBarButtonItem()
        trashButton.image = UIImage(systemName: "trash")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30))
        trashButton.setSize(CGSize(width: 30, height: 30), animated: false)
        return trashButton
    }()
    
    private lazy var attachButtonItem: InputBarButtonItem = {
        let attachButton = InputBarButtonItem()
        attachButton.image = UIImage(systemName: "plus")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30))
        attachButton.setSize(CGSize(width: 30, height: 30), animated: false)
        attachButton.onTouchUpInside { [weak self] item in
            self?.actionDelegate?.openAttachActionSheet()
        }
        return attachButton
    }()
    
    
    private lazy var shortPressRecognizer: UILongPressGestureRecognizer = {
        let longPressRecognizer = UILongPressGestureRecognizer()
        longPressRecognizer.minimumPressDuration = 0
        longPressRecognizer.delaysTouchesBegan = true
        return longPressRecognizer
    }()
    
    private lazy var longPressRecognizer: UILongPressGestureRecognizer = {
        let longPressRecognizer = UILongPressGestureRecognizer()
        longPressRecognizer.minimumPressDuration = 0.5
        longPressRecognizer.delaysTouchesBegan = true
        return longPressRecognizer
    }()
    
    weak var actionDelegate: MessageInputBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
        shortPressRecognizer.delegate = self
        longPressRecognizer.delegate = self
        
        
        //TextView
        inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 36)
        inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 36)
        inputTextView.layer.borderColor = Color.grayscale300.cgColor
        inputTextView.layer.borderWidth = 1
        inputTextView.layer.cornerRadius = 16
        inputTextView.layer.masksToBounds = true
        inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        inputTextView.isImagePasteEnabled = false
        
        setLeftStackViewWidthConstant(to: 36, animated: false)
        
        // SendButton
        setStackViewItems([sendButton], forStack: .right, animated: false)
        setRightStackViewWidthConstant(to: 36, animated: false)
        
        sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        sendButton.image = Icon.send.image
        
        // TODO: Resolve deprecated
        sendButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 4, bottom: 4, right: 6)
        sendButton.title = nil
        sendButton.layer.cornerRadius = 18
        sendButton.clipsToBounds = true
        sendButton.backgroundColor = tintColor
        separatorLine.isHidden = true
        
        isTranslucent = true
        
        self.middleContentViewPadding2 = middleContentViewPadding
    }
    
    var middleContentViewPadding2: UIEdgeInsets?
    
    func addAttachButton() {
        setStackViewItems([attachButtonItem], forStack: .left, animated: false)
        
        
        
            self.attachButtonItem.alpha = 1
            self.trashButtonItem.alpha = 0
        
    }
    
    func addSendButton() {
        setStackViewItems([sendButton], forStack: .right, animated: false)
        
        UIView.animate(withDuration: 0.2) {
            self.sendButton.alpha = 1
            self.micButtonItem.alpha = 0
        }
    }
    
    func addMicButton() {
        setStackViewItems([micButtonItem], forStack: .right, animated: false)
        
        UIView.animate(withDuration: 0.2) {
            self.sendButton.alpha = 0
            self.micButtonItem.alpha = 1
        }
    }
    
    private func addRecordingTrashIcon() {
        setStackViewItems([trashButtonItem], forStack: .left, animated: false)
        
        
        self.trashButtonItem.alpha = 1
        self.attachButtonItem.alpha = 0
        
    }
    
    @objc private func shortPressRecognizer2() {
        switch shortPressRecognizer.state {
        case .began:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            
            UIView.animate(withDuration: 0.2) {
                self.middleContentViewPadding.right = self.middleContentView?.frame.width ?? .zero
                self.addRecordingTrashIcon()
                self.contentView.layoutIfNeeded()
            }
        default:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            
            UIView.animate(withDuration: 0.2) {
                self.middleContentViewPadding.right = self.middleContentViewPadding2!.right
//                self.middleContentViewPadding.left = self.middleContentViewPadding.left
                self.addAttachButton()
                self.contentView.layoutIfNeeded()
            }
            
            UIView.animate(withDuration: 1) {
                self.micButtonItem.tintColor = .tintColor
//                self.micButtonItem.frame = .init(x: 0, y: 0, width: 36, height: 36)
            }
        }
    }
    
    @objc private func recordAudio() {
        switch longPressRecognizer.state {
        case .began:
            UIView.animate(withDuration: 0.2) {
                self.micButtonItem.tintColor = .red
//                self.micButtonItem.frame = .init(x: 0, y: 0, width: 60, height: 60)
            }
            actionDelegate?.audioRecording(.start)
        case .ended:
            UIView.animate(withDuration: 0.2) {
                self.micButtonItem.tintColor = .tintColor
//                self.micButtonItem.frame = .init(x: 0, y: 0, width: 60, height: 60)
            }
            return
//            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
//                self.actionDelegate?.audioRecording(.stop)
//            }
        default:
            return
        }
    }
}

extension MessageInputBarView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer === longPressRecognizer {
            recordAudio()
        } else {
            shortPressRecognizer2()
        }
        
        return true

    }
}
