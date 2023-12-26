import UIKit
import DesignKit
import MessageKit
import InputBarAccessoryView
import GalleryKit
import RealmSwift

protocol ChatDisplaying: AnyObject {
    func displaySomething()
}

private extension ChatViewController.Layout {
    // example
    enum Size {
        static let imageHeight: CGFloat = 90.0
    }
}

final class ChatViewController: MessagesViewController {
    fileprivate enum Layout {
        // template
    }
    
    private lazy var refreshController: UIRefreshControl = {
        let refreshController = UIRefreshControl()
        return refreshController
    }()
    
    private lazy var micButtonItem: InputBarButtonItem = {
        let micButtonItem = InputBarButtonItem()
        micButtonItem.image = UIImage(systemName: "mic.fill")
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
        interactor.loadSomething()
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
}

extension ChatViewController: ViewConfiguration {
    func buildViewHierarchy() {
        // template
    }
    
    func setupConstraints() {
        // template
    }

    func configureViews() {
        title = dto.recipientName
        configureMessageCollectionView()
        configureMessageInputBar()
    }
}

// MARK: - ChatDisplaying
extension ChatViewController: ChatDisplaying {
    func displaySomething() { 
        // template
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
//        configureMicrophoneButton()
    }
    
    func configureAttachButton() {
        let attachButton = InputBarButtonItem()
        attachButton.image = UIImage(systemName: "plus")
        attachButton.setSize(CGSize(width: 30, height: 30), animated: false)
        attachButton.onTouchUpInside { item in
            print("button pressed")
        }
        messageInputBar.setStackViewItems([attachButton], forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
    }
    
    func configureMicrophoneButton() {
        messageInputBar.setStackViewItems([micButtonItem], forStack: .right, animated: false)
        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: false)
    }
}
