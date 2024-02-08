import UIKit
import DesignKit
import InputBarAccessoryView
import Lottie

protocol MessageInputBarDelegate: AnyObject {
    func openAttachActionSheet()
    func audioRecording(_ state: RecordingState)
}

private extension MessageInputBarView.Layout {
    enum Texts {
        static let noLongerMember = Strings.GroupInfo.noLongerMember.localized()
        static let swipeToCancel = Strings.MessageInputBar.swipeToCancel.localized()
    }
}

final class MessageInputBarView: InputBarAccessoryView {
    fileprivate enum Layout { }
    
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
        micButtonItem.image = UIImage(systemName: "mic.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 26))
        micButtonItem.setSize(CGSize(width: 26, height: 26), animated: false)
        micButtonItem.contentMode = .scaleAspectFit
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
        longPressRecognizer.minimumPressDuration = 0.4
        longPressRecognizer.allowableMovement = 100
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
    
    private var cancelRecordingLabel: TextLabel = {
        let text = TextLabel(font: Font.lg.make(isBold: true))
        text.textColor = Color.grayscale600.uiColor
        text.text = "〈 \(Layout.Texts.swipeToCancel)"
        text.alpha = 0
        return text
    }()
    
    private let stopWatchView: StopWatchView = {
        let view = StopWatchView()
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var timerViewLeftAnchor = stopWatchView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -80)
    private lazy var middleContentViewPaddingOriginal = UIEdgeInsets()
    
    weak var actionDelegate: MessageInputBarDelegate?
    
    private let feedbackHapticMedium = UIImpactFeedbackGenerator(style: .medium)
    private let feedbackHapticSoft = UIImpactFeedbackGenerator(style: .soft)
    private let keyboardManager = KeyboardManager.shared
    
    private var isRecording = false
    
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
        inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 12)
        inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        inputTextView.layer.borderColor = Color.grayscale300.cgColor
        inputTextView.layer.borderWidth = 1
        inputTextView.layer.cornerRadius = 16
        inputTextView.layer.masksToBounds = true
        inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        inputTextView.isImagePasteEnabled = false
        
        setLeftStackViewWidthConstant(to: 36, animated: false)
        
        // SendButton
        //        setStackViewItems([sendButton], forStack: .right, animated: false)
        setRightStackViewWidthConstant(to: 36, animated: false)
        
        sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        sendButton.image = UIImage(systemName: "paperplane.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        
        // TODO: Resolve deprecated
        sendButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 4, bottom: 4, right: 6)
        sendButton.title = nil
        sendButton.layer.cornerRadius = 18
        sendButton.clipsToBounds = true
        sendButton.backgroundColor = tintColor
        separatorLine.isHidden = true
        
        isTranslucent = true
        
        middleContentViewPaddingOriginal = middleContentViewPadding
        
        configureStopWatch()
        
        let backgroundView = self.backgroundView
        backgroundView.alpha = 0.9
        self.backgroundView = backgroundView
        backgroundColor = backgroundColor?.withAlphaComponent(0.9)
    }
    
    func addAttachButton() {
        setStackViewItems([attachButtonItem], forStack: .left, animated: false)
        
        NSLayoutConstraint.activate([
            attachButtonItem.topAnchor.constraint(equalTo: leftStackView.topAnchor)
        ])
        
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
        
        NSLayoutConstraint.activate([
            micButtonItem.topAnchor.constraint(equalTo: rightStackView.topAnchor)
        ])
        
        UIView.animate(withDuration: 0.2) {
            self.sendButton.alpha = 0
            self.micButtonItem.alpha = 1
        }
    }
    
    func setupState(available: Bool) {
        if available {
            setup()
            configure()
            addAttachButton()
            addMicButton()
        } else {
            let messageButton = UIButton()
            messageButton.setTitle(Layout.Texts.noLongerMember, for: .normal)
            messageButton.backgroundColor = .clear
            messageButton.setTitleColor(Color.grayscale850.uiColor, for: .normal)
            messageButton.isUserInteractionEnabled = false
            messageButton.translatesAutoresizingMaskIntoConstraints = false
            messageButton.titleLabel?.adjustsFontSizeToFitWidth = true
            messageButton.heightAnchor.constraint(equalToConstant: 38).isActive = true
            setStackViewItems([], forStack: .left, animated: false)
            setStackViewItems([], forStack: .right, animated: false)
            setMiddleContentView(messageButton, animated: false)
        }
    }
}

private extension MessageInputBarView {
    func addRecordingTrashIcon() {
        attachButtonItem.alpha = 0
        cancelAudioAnimation.alpha = 1
        
        addSubview(cancelAudioAnimation)
        
        NSLayoutConstraint.activate([
            cancelAudioAnimation.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -16),
            cancelAudioAnimation.heightAnchor.constraint(equalToConstant: 82),
            cancelAudioAnimation.widthAnchor.constraint(equalToConstant: 82)
        ])
        
        if keyboardManager.isKeyboardVisible {
            bottomTrashConstraint.constant = 16
        } else {
            bottomTrashConstraint.constant = -16
        }
    }
    
    func cancelAudioRecordingAnimation() {
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
        let redAmount = redAmount < 0 ? 0 : redAmount
        return UIColor(
            red: Color.grayscale600.uiColor.redValue + redAmount,
            green: (Color.grayscale600.uiColor.greenValue - redAmount),
            blue: (Color.grayscale600.uiColor.blueValue - redAmount),
            alpha: 1.0
        )
    }
    
    func displayCancelRecordingLabel(show: Bool) {
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
}

@objc private extension MessageInputBarView {
    func panRecognizer() {
        let position = panGestureRecognizer.location(in: self)
        let trashPosition = cancelAudioAnimation.frame.origin
        
        let xDist = (trashPosition.x - position.x)
        let yDist = (trashPosition.y - position.y)
        let distance = sqrt((xDist * xDist) + (yDist * yDist))
        
        let proportionalDistance = 315 - distance
        let redAmount = proportionalDistance / 100
        
        cancelRecordingLabel.textColor = mixWhiteAndRed(redAmount: redAmount)
        
        if distance < 178 {
            cancelAudio()
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { [weak self] _ in
            if self?.isRecording == false {
                self?.cancelAudio()
            }
        }
    }
    
    func cancelAudio() {
        cancelRecordingLabel.textColor = Color.grayscale600.uiColor
        
        feedbackHapticSoft.prepare()
        feedbackHapticSoft.impactOccurred()
        
        stopTimer()
        resetAllInteractions()
        holdUserInteraction(for: 0.8)
        displayCancelRecordingLabel(show: false)
        cancelAudioRecordingAnimation()
        AudioRecorderManager.shared.cancelRecording()
    }
    
    func shortPressRecognizer() {
        switch shortGestureRecognizer.state {
        case .began:
            
            UIView.animate(withDuration: 0.1) {
                self.micButtonItem.tintColor = .red
                self.middleContentViewPadding.right = self.middleContentView?.frame.width ?? .zero
                self.contentView.layoutIfNeeded()
            } completion: { _ in
                self.middleContentView?.alpha = 0
                self.displayCancelRecordingLabel(show: true)
                
                UIView.animate(withDuration: 0.1) {
                    self.addRecordingTrashIcon()
                }
            }
        case .ended:
            micButtonItem.tintColor = .tintColor
            middleContentView?.alpha = 1
            displayCancelRecordingLabel(show: false)
            cancelRecordingLabel.textColor = Color.grayscale600.uiColor
                
            if !isRecording {
                holdUserInteraction(for: 0.4)
                feedbackHapticSoft.prepare()
                feedbackHapticSoft.impactOccurred()
                
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
    
    func recordAudio() {
        switch longGestureRecognizer.state {
        case .began:
            if AudioRecorderManager.shared.isAudioRecordingGranted() {
                DispatchQueue.main.async {
                    self.feedbackHapticMedium.prepare()
                    self.feedbackHapticMedium.impactOccurred()
                    self.isRecording = true
                    self.startTimer()
                    self.actionDelegate?.audioRecording(.start)
                }
            } else {
                actionDelegate?.audioRecording(.notGranted)
            }
        case .ended:
            if isRecording {
                stopTimer()
                isRecording = false
                feedbackHapticMedium.prepare()
                feedbackHapticMedium.impactOccurred()
                
                UIView.animate(withDuration: 0.4) {
                    self.middleContentViewPadding.right = self.middleContentViewPaddingOriginal.right
                    self.addAttachButton()
                    self.contentView.layoutIfNeeded()
                }
                
                cancelRecordingLabel.textColor = Color.grayscale600.uiColor
                displayCancelRecordingLabel(show: false)
                resetAllInteractions()
                holdUserInteraction(for: 0.6)
                actionDelegate?.audioRecording(.stop)
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
        Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { [weak self] _ in
            self?.micButtonItem.isUserInteractionEnabled = true
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
    
    func configureStopWatch() {
        addSubview(stopWatchView)
        
        NSLayoutConstraint.activate([
            stopWatchView.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: -32),
            stopWatchView.heightAnchor.constraint(equalToConstant: 32),
            stopWatchView.widthAnchor.constraint(equalToConstant: 80),
            timerViewLeftAnchor
        ])
    }
    
    func startTimer() {
        stopWatchView.startCounter()
        UIView.animate(withDuration: 0.2) {
            self.timerViewLeftAnchor.constant = -6
            self.layoutIfNeeded()
        }
    }
    
    func stopTimer() {
        stopWatchView.stopCounter()
        UIView.animate(withDuration: 0.2) {
            self.timerViewLeftAnchor.constant = -80
            self.layoutIfNeeded()
        }
    }
}
