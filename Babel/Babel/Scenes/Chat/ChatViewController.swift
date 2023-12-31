import UIKit
import DesignKit
import MessageKit
import InputBarAccessoryView
import GalleryKit
import RealmSwift

protocol ChatDisplaying: AnyObject {
    func displayMessage(_ localMessage: LocalMessage)
}

private extension ChatViewController.Layout {
    // example
    enum Size {
        static let imageHeight: CGFloat = 90.0
    }
}

final class ChatViewController: MessagesViewController {
    typealias Localizable = Strings.ChatView
    
    fileprivate enum Layout {
        // template
    }
    
    private lazy var titleLabel: TextLabel = {
        let label = TextLabel()
        label.text = dto.recipientName
        label.textAlignment = .center
        label.font = Font.md.make(isBold: true)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var descriptionLabel: TextLabel = {
        let label = TextLabel()
        label.textAlignment = .center
        label.font = Font.sm.uiFont
        label.adjustsFontSizeToFitWidth = true
        label.isHidden = true
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stack.axis = .vertical
        stack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnContactInfo)))
        return stack
    }()
    
    private lazy var refreshController: UIRefreshControl = {
        let refreshController = UIRefreshControl()
        return refreshController
    }()
    
    private lazy var micButtonItem: InputBarButtonItem = {
        let micButtonItem = InputBarButtonItem()
        micButtonItem.image = UIImage(systemName: "mic.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30))
        micButtonItem.setSize(CGSize(width: 30, height: 30), animated: false)
//        micButtonItem.addGestureRecognizer()
        return micButtonItem
    }()
    
    private(set) lazy var mkSender = MKSender(
        senderId: AccountInfo.shared.user!.id,
        displayName: AccountInfo.shared.user!.name
    )
    
    private(set) lazy var mkMessages = [MKMessage]()
    
    private var currentUser: User {
        AccountInfo.shared.user!
    }
    
    private let interactor: ChatInteracting
    private let dto: ChatDTO
    
    init(interactor: ChatInteracting, dto: ChatDTO) {
        self.interactor = interactor
        self.dto = dto
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        interactor.loadChatMessages()
        interactor.listenForNewChats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode =  .never
    }
    
    func messageSend(
        text: String? = nil,
        photo: UIImage? = nil,
        video: String? = nil,
        audio: String? = nil,
        audioDuration: Float = 0.0,
        location: String? = nil
    ) {
        let message = OutgoingMessage(
            chatId: dto.chatId,
            text: text,
            photo: photo,
            video: video,
            audio: audio,
            audioDuration: audioDuration,
            location: location,
            memberIds: [currentUser.id, dto.recipientId]
        )
        interactor.sendMessage(message: message)
    }
    
    func updateMicButtonStatus(show: Bool) {
        if show {
            addMicrophoneButton()
        } else {
            addSendButton()
        }
    }
}

extension ChatViewController: ViewConfiguration {
    func buildViewHierarchy() {
        navigationItem.titleView = stackView
    }
    
    func setupConstraints() {
        
    }

    func configureViews() {
        configureMessageCollectionView()
        configureMessageInputBar()
    }
}

// MARK: - ChatDisplaying
extension ChatViewController: ChatDisplaying {
    func displayMessage(_ localMessage: LocalMessage) {
        let incoming = IncomingMessage(messagesViewController: self)
        mkMessages.append(incoming.createMessage(localMessage: localMessage)!)
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(animated: true)
    }
}

@objc private extension ChatViewController {
    func didTapOnContactInfo() {
        print("didTapOnContactInfo")
    }
}

private extension ChatViewController {
    func configureMessageCollectionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnInputBarHeightChanged = true
        
        messagesCollectionView.refreshControl = refreshController
    }
    
    func configureMessageInputBar() {
        messageInputBar.delegate = self
        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.backgroundView.backgroundColor = Color.backgroundPrimary.uiColor
        messageInputBar.inputTextView.backgroundColor = Color.backgroundPrimary.uiColor
        
        configureAttachButton()
        addMicrophoneButton()
    }
    
    func configureAttachButton() {
        let attachButton = InputBarButtonItem()
        attachButton.image = UIImage(systemName: "plus")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 30))
        attachButton.setSize(CGSize(width: 30, height: 30), animated: false)
        attachButton.onTouchUpInside { item in
            print("button pressed")
        }
        messageInputBar.setStackViewItems([attachButton], forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
    }
    
    func addMicrophoneButton() {
        messageInputBar.setStackViewItems([micButtonItem], forStack: .right, animated: false)
        messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
    }
    
    func addSendButton() {
        let sendButton = messageInputBar.sendButton
        sendButton.setTitle(Localizable.send, for: .normal)
        messageInputBar.setStackViewItems([sendButton], forStack: .right, animated: false)
        messageInputBar.setRightStackViewWidthConstant(to: 55, animated: false)
    }
    
    func updateTypingIndicator(_ show: Bool) {
        descriptionLabel.text = Localizable.typing
        animateDescription(show: show)
    }
    
    func animateDescription(show: Bool) {
        UIView.animate(withDuration: 0.2) {
            if show {
                self.descriptionLabel.isHidden = false
                self.stackView.layoutIfNeeded()
            } else {
                self.descriptionLabel.isHidden = true
            }
        }
    }
}
