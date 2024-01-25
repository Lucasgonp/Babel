import UIKit
import DesignKit
import MessageKit
import InputBarAccessoryView

protocol ChatBotDisplaying: AnyObject {
    func displayMessage(_ localMessage: LocalMessage)
    func displayRefreshedMessages(_ localMessage: LocalMessage)
    func refreshNewMessages()
    func endRefreshing()
    func updateTypingIndicator(_ isTyping: Bool)
    func updateMessage(_ localMessage: LocalMessage)
}

final class ChatBotViewController: MessagesViewController {
    typealias Localizable = Strings.ChatView
    
    private lazy var titleLabel: TextLabel = {
        let label = TextLabel()
        label.text = dto.name
        label.textAlignment = .center
        label.font = Font.md.make(isBold: true)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let descriptionLabel: TextLabel = {
        let label = TextLabel()
        label.textAlignment = .center
        label.font = Font.sm.uiFont
        label.adjustsFontSizeToFitWidth = true
        label.text = Localizable.typing.localized()
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let labelsStack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        labelsStack.axis = .vertical
        let stackView = UIStackView(arrangedSubviews: [titleViewAvatar, labelsStack])
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnContactInfo)))
        return stackView
    }()
    
    private lazy var titleViewAvatar: ImageView = {
        let imageView = ImageView(frame: CGRect(x: .zero, y: .zero, width: 38, height: 38))
        imageView.image = dto.avatarImage
        imageView.layer.cornerRadius = 19
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var spinnerView: SpinnerView = {
        let spinnerView = SpinnerView(backgroundColor: .clear, shouldBlur: true)
        spinnerView.delegate = self
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        return spinnerView
    }()
    
    private lazy var inputBar: InputBarAccessoryView = {
        let inputBar = MessageBotInputBarView()
        inputBar.delegate = self
        return inputBar
    }()
    
    var mkSender: MKSender {
        MKSender(senderId: currentUser.id, displayName: currentUser.name, avatarLink: currentUser.avatarLink)
    }
    
    private(set) var mkMessages = [MKMessage]()
    
    private let refreshController = UIRefreshControl()
    private let currentUser = UserSafe.shared.user
    private let interactor: ChatBotInteractorProtocol
    
    private(set) var dto: ChatBotDTO
    
    var viewModel: ChatBotViewModel!
    
    init(interactor: ChatBotInteractorProtocol, dto: ChatBotDTO) {
        self.interactor = interactor
        self.dto = dto
        super.init(nibName: nil, bundle: nil)
        self.messageInputBar = inputBar
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        interactor.removeListeners()
    }
    
    func messageSend(text: String? = nil) {
        let message = OutgoingMessage(
            chatId: dto.chatId,
            text: text,
            memberIds: [currentUser.id, dto.id]
        )
        interactor.sendMessage(message)
    }
    
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 { return true }
        
        let previousIndexPath = IndexPath(row: 0, section: indexPath.section - 1)
        let previousMessage = messageForItem(at: previousIndexPath, in: messagesCollectionView)
        
        if message.sentDate.isInSameDayOf(date: previousMessage.sentDate) {
            return false
        }
        
        return true
    }
    
    override func scrollViewDidEndDecelerating(_: UIScrollView) {
        if refreshController.isRefreshing {
            interactor.refreshNewMessages()
        }
    }
}

//MARK: - ViewConfiguration
extension ChatBotViewController: ViewConfiguration {
    func buildViewHierarchy() {
        navigationItem.titleView = stackView
    }
    
    func configureViews() {
        let backButton = UIBarButtonItem(title: String(), style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        configureMessageCollectionView()
        configureMessageInputBar()
        
        // TODO: showMessageTimestampOnSwipeLeft = true
    }
}

// MARK: - ChatDisplaying
extension ChatBotViewController: ChatBotDisplaying {
    func displayMessage(_ localMessage: LocalMessage) {
        let incoming = IncomingMessage(messagesViewController: self)
        let mkMessage = incoming.createMessage(localMessage: localMessage)!
        mkMessages.append(mkMessage)
        DispatchQueue.main.async {
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToLastItem(animated: true)
        }
    }
    
    func displayRefreshedMessages(_ localMessage: LocalMessage) {
        let incoming = IncomingMessage(messagesViewController: self)
        mkMessages.insert(incoming.createMessage(localMessage: localMessage)!, at: 0)
        DispatchQueue.main.async {
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToLastItem(animated: true)
        }
    }
    
    func refreshNewMessages() {
        DispatchQueue.main.async {
            self.messagesCollectionView.reloadDataAndKeepOffset()
            self.refreshController.endRefreshing()
        }
    }
    
    func endRefreshing() {
        refreshController.endRefreshing()
    }
    
    func updateTypingIndicator(_ isTyping: Bool) {
        updateTypingIndicator(show: isTyping)
    }
    
    func updateMessage(_ localMessage: LocalMessage) {
        for index in 0 ..< mkMessages.count {
            let tempMessage = mkMessages[index]
            if localMessage.id == tempMessage.messageId {
                mkMessages[index].status = localMessage.status
                mkMessages[index].readDate = localMessage.readDate
                
                RealmManager.shared.saveToRealm(localMessage)
            }
            
            if mkMessages[index].status == kREAD {
                self.messagesCollectionView.reloadData()
            }
        }
    }
}

//MARK: - LoadingViewDelegate
extension ChatBotViewController: LoadingViewDelegate {
    func dismissLoadingView() {
        spinnerView.removeFromSuperview()
    }
}

//MARK: - Actions
@objc private extension ChatBotViewController {
    func didTapOnContactInfo() {
        interactor.didTapOnContactInfo()
    }
}

//MARK: - Private methods
private extension ChatBotViewController {
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
    }
    
    func updateTypingIndicator(show: Bool) {
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
    
    func showLoadingView() {
        view.addSubview(spinnerView)
        view.fillWithSubview(subview: spinnerView)
    }
}
