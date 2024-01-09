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
    
    private lazy var bottomTrashConstraint: NSLayoutConstraint = {
        let constraint = cancelAudioAnimation.bottomAnchor.constraint(equalTo: bottomAnchor)
        constraint.isActive = true
        return constraint
    }()
    
    private lazy var middleContentViewPaddingOriginal = UIEdgeInsets()
    
    weak var actionDelegate: MessageInputBarDelegate?
    
    private let feedbackHaptic = UIImpactFeedbackGenerator(style: .heavy)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setupRecognizers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
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
        
        if KeyboardManager.shared.isKeyboardVisible {
            bottomTrashConstraint.constant = 16
        } else {
            bottomTrashConstraint.constant = -16
        }
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
    
    func mixWhiteAndRed(redAmount: CGFloat) -> UIColor {
        var redAmount = redAmount < 0 ? 0 : redAmount
        return UIColor(
            red: Color.grayscale600.uiColor.redValue + redAmount,
            green: (Color.grayscale600.uiColor.greenValue - redAmount),
            blue: (Color.grayscale600.uiColor.blueValue - redAmount),
            alpha: 1.0
        )
    }
    
    @objc private func panRecognizer() {
        let position = panGestureRecognizer.location(in: contentView)
        let position2 = panGestureRecognizer.location(in: self)
        
        let trashPosition = cancelAudioAnimation.frame.origin
        
        let xDist = (trashPosition.x - position2.x)
        let yDist = (trashPosition.y - position2.y)
        let distance = sqrt((xDist * xDist) + (yDist * yDist))
        
        print("distance: \(distance)")
        
        let proportionalDistance = 315 - distance
        let redAmount = proportionalDistance / 100
        
        print("red amount: \(redAmount)")
        
        cancelRecordingLabel.textColor = mixWhiteAndRed(redAmount: redAmount)
        
        //315
        //191
//            let positionX = (position.x / 320) * 2
//            let positionY = (position.y) / 20
//            
//            let redAmount = (positionX + positionY) / 4
//            
//            print("red amount: \(redAmount)")
//            
//            cancelRecordingLabel.textColor = mixWhiteAndRed(redAmount: redAmount)
        
        if position.x < 163.0 && position.y > -42.33 {
            
            cancelRecordingLabel.textColor = Color.grayscale600.uiColor
            
            // Cancel audio
            feedbackHaptic.impactOccurred()
            
            resetAllInteractions()
            holdUserInteraction(for: 0.4)
            displayCancelRecordingLabel(show: false)
            cancelAudioRecordingAnimation()
//          AudioRecorderManager.shared.cancelRecording()
            print("cancelar audio")
        }
    }
    
    private var cancelRecordingLabel: TextLabel = {
        let text = TextLabel(font: Font.lg.make(isBold: true))
        text.textColor = Color.grayscale600.uiColor
        text.text = "〈 Swipe to cancel"
        text.alpha = 0
        return text
    }()
    
    private func displayCancelRecordingLabel(show: Bool) {
        if show {
            contentView.fillWithSubview(subview: cancelRecordingLabel, spacing: .init(top: 0, left: 42, bottom: 0, right: 42))
            UIView.animate(withDuration: 0.2) {
                self.cancelRecordingLabel.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.cancelRecordingLabel.alpha = 0
            } completion: { _ in
                self.cancelRecordingLabel.removeFromSuperview()
            }
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
                self.displayCancelRecordingLabel(show: true)
                
                UIView.animate(withDuration: 0.1) {
                    self.addRecordingTrashIcon()
                    // func show message
                }
            }
        case .ended:
            micButtonItem.tintColor = .tintColor
            middleContentView?.alpha = 1
            displayCancelRecordingLabel(show: false)
            cancelRecordingLabel.textColor = Color.grayscale600.uiColor
                
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
                        if self.cancelRecordingLabel.alpha == 1 {
                            self.displayCancelRecordingLabel(show: false)
                            self.cancelRecordingLabel.textColor = Color.grayscale600.uiColor
                        }
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
//            actionDelegate?.audioRecording(.start)
        case .ended:
            if isRecording {
                isRecording = false
                feedbackHaptic.impactOccurred()
                
                UIView.animate(withDuration: 0.4) {
                    self.middleContentViewPadding.right = self.middleContentViewPaddingOriginal.right
                    
                    self.addAttachButton()
                    self.contentView.layoutIfNeeded()
                }
                
                cancelRecordingLabel.textColor = Color.grayscale600.uiColor
                displayCancelRecordingLabel(show: false)
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
        panGestureRecognizer.isEnabled = false
        shortGestureRecognizer.isEnabled = false
        
        longGestureRecognizer.isEnabled = true
        panGestureRecognizer.isEnabled = true
        shortGestureRecognizer.isEnabled = true
    }
    
    func setupRecognizers() {
        shortGestureRecognizer.delegate = self
        longGestureRecognizer.delegate = self
        panGestureRecognizer.delegate = self
    }
}

extension UIColor {
    var redValue: CGFloat{ return CIColor(color: self).red }
    var greenValue: CGFloat{ return CIColor(color: self).green }
    var blueValue: CGFloat{ return CIColor(color: self).blue }
    var alphaValue: CGFloat{ return CIColor(color: self).alpha }
}
