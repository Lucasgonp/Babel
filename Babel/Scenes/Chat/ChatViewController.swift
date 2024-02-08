import UIKit
import DesignKit
import MessageKit
import InputBarAccessoryView
import GalleryKit
import StorageKit

protocol ChatDisplaying: AnyObject {
    func displayMessage(_ localMessage: LocalMessage)
    func displayRefreshedMessages(_ localMessage: LocalMessage)
    func refreshNewMessages()
    func updateTypingIndicator(_ isTyping: Bool)
    func updateMessage(_ localMessage: LocalMessage)
    func audioNotGranted()
}

private extension ChatViewController.Layout {
    enum Texts {
        static let typing = Strings.ChatView.typing.localized()
        static let camera = Strings.ChatView.ActionSheet.camera.localized()
        static let library = Strings.ChatView.ActionSheet.library.localized()
        static let shareLocation = Strings.ChatView.ActionSheet.shareLocation.localized()
        static let cancel = Strings.Commons.cancel.localized()
        static let accessNotGranted = Strings.Commons.accessNotGranted.localized()
        static let audioNotGrantedDescription = Strings.AudioAccess.permissionNotGranted.localized()
        static let grantAccess = Strings.Commons.grantAccess.localized()
    }
}

final class ChatViewController: MessagesViewController {
    fileprivate enum Layout { }
    
    private lazy var titleLabel: TextLabel = {
        let label = TextLabel()
        label.text = dto.recipientName
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
        label.text = Layout.Texts.typing
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
    
    private let titleViewAvatar: ImageView = {
        let imageView = ImageView(frame: CGRect(x: .zero, y: .zero, width: 38, height: 38))
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
    
    private lazy var attachActionSheet = makeAttachActionSheet()
    private var galleryController: GalleryController?
    
    private lazy var inputBar: InputBarAccessoryView = {
        let inputBar = MessageInputBarView()
        inputBar.delegate = self
        inputBar.actionDelegate = self
        return inputBar
    }()
    
    private(set) lazy var audioController = AudioController(messageCollectionView: messagesCollectionView)
    
    var mkSender: MKSender {
        MKSender(senderId: currentUser.id, displayName: currentUser.name, avatarLink: currentUser.avatarLink)
    }
    
    private(set) var mkMessages = [MKMessage]()
    
    private var shouldLoadMoreMessages = false
    private let currentUser = UserSafe.shared.user
    private let interactor: ChatInteractorProtocol
    
    let dto: ChatDTO
    
    init(interactor: ChatInteractorProtocol, dto: ChatDTO) {
        self.interactor = interactor
        self.dto = dto
        super.init(nibName: nil, bundle: nil)
        self.messageInputBar = inputBar
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        interactor.removeListeners()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
        interactor.loadChatMessages()
        interactor.registerObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode =  .never
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        interactor.resetTypingIndicator()
        audioController.stopAnyOngoingPlaying()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
    }
    
    func messageSend(
        text: String? = nil,
        photo: UIImage? = nil,
        video: MediaVideo? = nil,
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
    
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 { return true }
        
        let previousIndexPath = IndexPath(row: 0, section: indexPath.section - 1)
        let previousMessage = messageForItem(at: previousIndexPath, in: messagesCollectionView)
        
        if message.sentDate.isInSameDayOf(date: previousMessage.sentDate) {
            return false
        }
        
        return true
    }
    
    override func scrollViewDidScroll(_: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = messagesCollectionView.contentOffset
        visibleRect.size = messagesCollectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = messagesCollectionView.indexPathForItem(at: visiblePoint) else {
            return
        }
        
        if indexPath.section <= 4 && shouldLoadMoreMessages && (dto.allLocalMessages?.count ?? 0) > dto.displayingMessagesCount {
            shouldLoadMoreMessages = false
            interactor.refreshNewMessages()
        }
    }
    
    func updateTypingObserver() {
        interactor.updateTypingObserver()
    }
}

//MARK: - ViewConfiguration
extension ChatViewController: ViewConfiguration {
    func buildViewHierarchy() {
        navigationItem.titleView = stackView
    }
    
    func configureViews() {
        let backButton = UIBarButtonItem(title: String(), style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        configureMessageCollectionView()
        configureMessageInputBar()
        
        titleViewAvatar.setImage(with: dto.recipientAvatarURL) { [weak self] image in
            self?.titleViewAvatar.image = image ?? Image.avatarPlaceholder.image
            self?.titleViewAvatar.frame = CGRect(x: 0, y: 0, width: 38, height: 38)
            self?.stackView.layoutIfNeeded()
        }
        
        let savedWallpaper = StorageLocal.shared.getString(key: kCHATWALLPAPER)
        var defaultWallpaper = UserInterface.style == .dark ? Image.chatBackgroundImage1 : Image.chatBackgroundImage12
        let wallpaper = Image.allImages.first(where: { $0.name == savedWallpaper }) ?? defaultWallpaper
        let imageView = UIImageView(image: wallpaper.image)
        imageView.alpha = 0.8
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        messagesCollectionView.backgroundView = imageView
        
        // TODO: showMessageTimestampOnSwipeLeft = true
    }
}

// MARK: - ChatDisplaying
extension ChatViewController: ChatDisplaying {
    func displayMessage(_ localMessage: LocalMessage) {
        let incoming = IncomingMessage(messagesViewController: self)
        let mkMessage = incoming.createMessage(localMessage: localMessage)!
        mkMessages.append(mkMessage)
        DispatchQueue.main.async {
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToLastItem(animated: true)
        }
        
        shouldLoadMoreMessages = true
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
        }
        
        shouldLoadMoreMessages = true
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
        
        shouldLoadMoreMessages = true
    }
    
    func audioNotGranted() {
        let title = Layout.Texts.accessNotGranted
        let message = Layout.Texts.audioNotGrantedDescription
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let grantAction = UIAlertAction(title: Layout.Texts.grantAccess, style: .cancel) { _ in
            guard let appSettingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(appSettingsURL)
        }
        alert.addAction(grantAction)
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - LoadingViewDelegate
extension ChatViewController: LoadingViewDelegate {
    func dismissLoadingView() {
        spinnerView.removeFromSuperview()
    }
}

//MARK: - MessageInputBarDelegate
extension ChatViewController: MessageInputBarDelegate {
    func openAttachActionSheet() {
        present(attachActionSheet, animated: true)
    }
    
    func audioRecording(_ state: RecordingState) {
        interactor.audioRecording(state)
    }
}

//MARK: - Actions
@objc private extension ChatViewController {
    func didTapOnContactInfo() {
        interactor.didTapOnContactInfo()
    }
    
    func didTapOnBackButton() {
        interactor.didTapOnBackButton()
    }
}

//MARK: - Private methods
private extension ChatViewController {
    func configureMessageCollectionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnInputBarHeightChanged = true
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
        let inputBar = messageInputBar as? MessageInputBarView
        inputBar?.addAttachButton()
    }
    
    func addMicrophoneButton() {
        let inputBar = messageInputBar as? MessageInputBarView
        inputBar?.addMicButton()
    }
    
    func addSendButton() {
        let inputBar = messageInputBar as? MessageInputBarView
        inputBar?.addSendButton()
    }
    
    func updateTypingIndicator(show: Bool) {
        descriptionLabel.text = Layout.Texts.typing
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
    
    func makeAttachActionSheet() -> UIAlertController {
        let cameraImage = UIImage(systemName: "camera")?.withRenderingMode(.alwaysTemplate)
        let cameraAction = UIAlertAction(title: Layout.Texts.camera, style: .default, image: cameraImage, handler: { [weak self] _ in
            self?.showLoadingView()
            self?.showGalleryView(configuration: .camera)
        })
        
        let libraryImage = UIImage(systemName: "photo")?.withRenderingMode(.alwaysTemplate)
        let libraryAction = UIAlertAction(title: Layout.Texts.library, style: .default, image: libraryImage, handler: { [weak self] _ in
            self?.showLoadingView()
            self?.showGalleryView(configuration: .library)
        })
        
        let locationImage = UIImage(systemName: "mappin.and.ellipse")?.withRenderingMode(.alwaysTemplate)
        let locationAction = UIAlertAction(title: Layout.Texts.shareLocation, style: .default, image: locationImage, handler: { [weak self] _ in
            LocationManager.shared.authorizeLocationAccess { [weak self] in
                LocationManager.shared.startUpdating()
                self?.messageSend(location: kLOCATION)
            }
        })
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(libraryAction)
        actionSheet.addAction(locationAction)
        actionSheet.addAction(UIAlertAction(title: Layout.Texts.cancel, style: .cancel, handler: nil))
        
        return actionSheet
    }
    
    func showLoadingView() {
        view.addSubview(spinnerView)
        view.fillWithSubview(subview: spinnerView)
    }
    
    func showGalleryView(configuration: GalleryController.Configuration) {
        galleryController = GalleryController()
        galleryController?.configuration = configuration
        galleryController?.showMediaPicker(
            from: navigationController,
            loadingViewDelegate: self,
            completion: { [weak self] items in
                self?.galleryController = nil
                
                if let singlePhoto = items.singlePhoto {
                    self?.showLoadingView()
                    self?.messageSend(photo: singlePhoto.image)
                }
                
                if let singleVideo = items.singleVideo {
                    self?.showLoadingView()
                    self?.messageSend(video: singleVideo)
                }
            })
    }
}
