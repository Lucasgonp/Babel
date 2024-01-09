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
        micButtonItem.addGestureRecognizer(shortGestureRecognizer)
        micButtonItem.addGestureRecognizer(longGestureRecognizer)
        micButtonItem.addGestureRecognizer(panGestureRecognizer)
        return micButtonItem
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
    
    private lazy var shortGestureRecognizer: UILongPressGestureRecognizer = {
        let longPressRecognizer = UILongPressGestureRecognizer()
        longPressRecognizer.minimumPressDuration = 0
        longPressRecognizer.addTarget(self, action: #selector(shortPressRecognizer))
        return longPressRecognizer
    }()
    
    private lazy var longGestureRecognizer: UILongPressGestureRecognizer = {
        let longPressRecognizer = UILongPressGestureRecognizer()
        longPressRecognizer.minimumPressDuration = 0.5
        longPressRecognizer.delaysTouchesBegan = true
        longPressRecognizer.addTarget(self, action: #selector(recordAudio))
        return longPressRecognizer
    }()
    
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let longPressRecognizer = UIPanGestureRecognizer()
        longPressRecognizer.addTarget(self, action: #selector(panRecognizer))
        return longPressRecognizer
    }()
    
    private let trashButtonItem: InputBarButtonItem = {
        let trashButton = InputBarButtonItem()
        trashButton.image = UIImage(systemName: "trash")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30))
        trashButton.setSize(CGSize(width: 30, height: 30), animated: false)
        return trashButton
    }()
    
    private lazy var middleContentViewPaddingOriginal = UIEdgeInsets()
    
    weak var actionDelegate: MessageInputBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        // GestureRecognizers
        shortGestureRecognizer.delegate = self
        longGestureRecognizer.delegate = self
        panGestureRecognizer.delegate = self
        
        
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
        
        middleContentViewPaddingOriginal = middleContentViewPadding
    }
    
    func addAttachButton() {
        setStackViewItems([attachButtonItem], forStack: .left, animated: false)
        attachButtonItem.alpha = 1
        trashButtonItem.alpha = 0
        
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
//        let infoCancelButton = InputBarButtonItem()
//        infoCancelButton.image = UIImage(systemName: "chevron.left")
//        infoCancelButton.setTitle("Swipe to cancel", for: .normal)
        setStackViewItems([trashButtonItem], forStack: .left, animated: false)
        trashButtonItem.alpha = 1
        attachButtonItem.alpha = 0
    }
    
    private var shouldCancelAudio = false
    
    @objc private func panRecognizer() {
        let position = panGestureRecognizer.location(in: contentView)
        shouldCancelAudio = position.x < 163.0 && position.y > -42.33
    }
    
    @objc private func shortPressRecognizer() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        
        switch shortGestureRecognizer.state {
        case .began:
            generator.impactOccurred()
            
            UIView.animate(withDuration: 0.2) {
                self.micButtonItem.tintColor = .red
                self.middleContentViewPadding.right = self.middleContentView?.frame.width ?? .zero + 12
                self.middleContentView?.alpha = 0.5
                self.addRecordingTrashIcon()
                self.contentView.layoutIfNeeded()
            }
        case .ended:
            generator.impactOccurred()
            
            UIView.animate(withDuration: 0.2) {
                self.micButtonItem.tintColor = .tintColor
                self.middleContentViewPadding.right = self.middleContentViewPaddingOriginal.right
                self.middleContentView?.alpha = 1
                self.addAttachButton()
                self.contentView.layoutIfNeeded()
            }
        default:
            return
        }
    }
    
    @objc private func recordAudio() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        
        switch longGestureRecognizer.state {
        case .began:
            generator.impactOccurred()
            return
            //                actionDelegate?.audioRecording(.start)
        case .ended:
            generator.impactOccurred()
            
            UIView.animate(withDuration: 0.2) {
                //                    self.micButtonItem.tintColor = .tintColor
                self.middleContentViewPadding.right = self.middleContentViewPaddingOriginal.right
                self.middleContentView?.alpha = 1
                self.addAttachButton()
                self.contentView.layoutIfNeeded()
            }
            
            if shouldCancelAudio {
                shouldCancelAudio = false
                print("cancelar audio")
//                AudioRecorderManager.shared.cancelRecording()
            } else {
                print("mandar audio")
            }
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
        return true
    }
}
