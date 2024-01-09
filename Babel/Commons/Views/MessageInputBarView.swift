import UIKit
import DesignKit
import InputBarAccessoryView
import Lottie

protocol MessageInputBarDelegate: AnyObject {
    func openAttachActionSheet()
    func audioRecording(_ state: RecordingState)
}

final class MessageInputBarView: InputBarAccessoryView {
    private let cancelAudioAnimation: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "TrashAnimation")
        animationView.frame = CGRect(x: 0, y: 0, width: 82, height: 82)
        animationView.contentMode = .scaleToFill
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 1.0
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
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
    
    private lazy var middleContentViewPaddingOriginal = UIEdgeInsets()
    
    weak var actionDelegate: MessageInputBarDelegate?
    
    private let feedbackHaptic = UIImpactFeedbackGenerator(style: .heavy)
    
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
        cancelAudioAnimation.alpha = 0
        
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
        attachButtonItem.alpha = 0
        cancelAudioAnimation.alpha = 1
        
        addSubview(cancelAudioAnimation)
        
        NSLayoutConstraint.activate([
            cancelAudioAnimation.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -16),
            cancelAudioAnimation.heightAnchor.constraint(equalToConstant: 82),
            cancelAudioAnimation.widthAnchor.constraint(equalToConstant: 82)
        ])
        
        // Always false
//        if keyboardListener.isVisible {
//            NSLayoutConstraint.activate([
//                cancelAudioAnimation.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)
//            ])
//        } else {
            NSLayoutConstraint.activate([
                cancelAudioAnimation.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
            ])
//        }
    }
    
    private func cancelAudioRecordingAnimation() {
        UIView.animate(withDuration: 0.2) {
            self.micButtonItem.tintColor = .tintColor
            self.middleContentViewPadding.right = self.middleContentViewPaddingOriginal.right
            self.middleContentView?.alpha = 1
            self.contentView.layoutIfNeeded()
        }
        
        cancelAudioAnimation.play { completed in
            if completed {
                self.isRecording = false
                UIView.animate(withDuration: 0.2) {
                    self.cancelAudioAnimation.alpha = 0
                    self.addAttachButton()
                }
            }
        }
    }
    
    @objc private func panRecognizer() {
        let position = panGestureRecognizer.location(in: contentView)
        if position.x < 163.0 && position.y > -42.33 {
            // Cancel audio
            feedbackHaptic.impactOccurred()
            
            resetAllInteractions()
            holdUserInteraction(for: 0.4)
            cancelAudioRecordingAnimation()
//          AudioRecorderManager.shared.cancelRecording()
            print("cancelar audio")
        }
    }
    
    @objc private func shortPressRecognizer() {
        switch shortGestureRecognizer.state {
        case .began:
            feedbackHaptic.impactOccurred()
            
            UIView.animate(withDuration: 0.1) {
                self.micButtonItem.tintColor = .red
                self.middleContentViewPadding.right = self.middleContentView?.frame.width ?? .zero
                self.contentView.layoutIfNeeded()
            } completion: { _ in
                self.middleContentView?.alpha = 0
                
                UIView.animate(withDuration: 0.1) {
                    self.addRecordingTrashIcon()
                }
            }
        case .ended:
                micButtonItem.tintColor = .tintColor
                middleContentView?.alpha = 1
                
            if !isRecording {
                holdUserInteraction(for: 0.4)
                feedbackHaptic.impactOccurred()
                UIView.animate(withDuration: 0.1) {
                    self.middleContentViewPadding.right = self.middleContentViewPaddingOriginal.right
                    self.middleContentView?.alpha = 1
                    self.contentView.layoutIfNeeded()
                } completion: { _ in
                    self.middleContentView?.alpha = 1
                    
                    UIView.animate(withDuration: 0.1) {
                        self.addAttachButton()
                    }
                }
            }
        default:
            return
        }
    }
    
    private var isRecording = false
    
    @objc private func recordAudio() {
        switch longGestureRecognizer.state {
        case .began:
            feedbackHaptic.impactOccurred()
            isRecording = true
            
            return
//                actionDelegate?.audioRecording(.start)
        case .ended:
            if isRecording {
                isRecording = false
                feedbackHaptic.impactOccurred()
                
                UIView.animate(withDuration: 0.4) {
                    self.middleContentViewPadding.right = self.middleContentViewPaddingOriginal.right
                    
                    self.addAttachButton()
                    self.contentView.layoutIfNeeded()
                }
                
                resetAllInteractions()
                holdUserInteraction(for: 0.6)
                print("send audio")
            }
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

private extension MessageInputBarView {
    func holdUserInteraction(for seconds: Double) {
        micButtonItem.isUserInteractionEnabled = false
        Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { _ in
            self.micButtonItem.isUserInteractionEnabled = true
        }
    }
    
    func resetAllInteractions() {
        longGestureRecognizer.isEnabled = false
        longGestureRecognizer.isEnabled = true
        panGestureRecognizer.isEnabled = false
        panGestureRecognizer.isEnabled = true
        shortGestureRecognizer.isEnabled = false
        shortGestureRecognizer.isEnabled = true
    }
}

//extension UIApplication {
//    var isKeyboardPresented: Bool {
//        if let keyboardWindowClass = NSClassFromString("UIRemoteKeyboardWindow"), self.windows.contains(where: { $0.isKind(of: keyboardWindowClass) }) {
//            return true
//        } else {
//            return false
//        }
//    }
//}
