import UIKit
import DesignKit
import MessageKit
import InputBarAccessoryView
import GalleryKit
import StorageKit

protocol GroupInfoUpdateProtocol: AnyObject {
    func didUpdateGroupInfo(dto: EditGroupDTO)
}

protocol ChatGroupDisplaying: AnyObject {
    func displayMessage(_ localMessage: LocalMessage)
    func displayRefreshedMessages(_ localMessage: LocalMessage)
    func refreshNewMessages()
    func updateTypingIndicator(_ isTyping: Bool)
    func didUpdateGroupInfo(_ groupInfo: Group)
    func updateMessage(_ localMessage: LocalMessage)
    func audioNotGranted()
    func endRefreshing()
    func setLoading(_ show: Bool)
}

private extension ChatGroupViewController.Layout {
    enum Texts {
        static let typing = Strings.ChatView.typing.localized()
        static let camera = Strings.ChatView.ActionSheet.camera.localized()
        static let library = Strings.ChatView.ActionSheet.library.localized()
        static let shareLocation = Strings.ChatView.ActionSheet.shareLocation.localized()
        static let cancel = Strings.Commons.cancel.localized()
        static let accessNotGranted = Strings.Commons.accessNotGranted.localized()
        static let audioAccessNotGranted = Strings.AudioAccess.permissionNotGranted.localized()
        static let grantAccess = Strings.Commons.grantAccess.localized()
    }
}

final class ChatGroupViewController: MessagesViewController {
    fileprivate enum Layout { }
    
    private lazy var titleLabel: TextLabel = {
        let label = TextLabel()
        label.text = dto.groupInfo.name
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
        let imageView = ImageView()
        imageView.layer.cornerRadius = 19
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
    
    private let refreshController = UIRefreshControl()
    private let currentUser = UserSafe.shared.user
    private let interactor: ChatGroupInteractor
    
    private(set) var dto: ChatGroupDTO
    
    init(interactor: ChatGroupInteractor, dto: ChatGroupDTO) {
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
        
        //TODO: check if its necessary
//        FirebaseRecentListener.shared.resetRecentCounter(chatRoomId: chatId)
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
        let memberIds = dto.membersIds
        let message = OutgoingMessage(
            chatId: dto.chatId,
            text: text,
            photo: photo,
            video: video,
            audio: audio,
            audioDuration: audioDuration,
            location: location,
            memberIds: memberIds
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
        if indexPath.section == 0 {
            return true
        }
        
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
    
    func updateTypingObserver() {
        interactor.updateTypingObserver()
    }
}

extension ChatGroupViewController: ViewConfiguration {
    func buildViewHierarchy() {
        navigationItem.titleView = stackView
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleViewAvatar.heightAnchor.constraint(equalToConstant: 38),
            titleViewAvatar.widthAnchor.constraint(equalToConstant: 38)
        ])
    }
    
    func configureViews() {
        let backButton = UIBarButtonItem(title: String(), style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        configureMessageCollectionView()
        configureMessageInputBar()
        
        titleViewAvatar.setImage(with: dto.groupInfo.avatarLink) { [weak self] image in
            self?.titleViewAvatar.image = image ?? Image.avatarGroupPlaceholder.image
        }
        
        if let savedWallpaper = StorageLocal.shared.getString(key: kCHATWALLPAPER),
           let wallpaper = Image.allImages.first(where: { $0.name == savedWallpaper }) {
            let imageView = UIImageView(image: wallpaper.image)
            imageView.alpha = 0.8
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            messagesCollectionView.backgroundView = imageView
        }
        
        // TODO: showMessageTimestampOnSwipeLeft = true
    }
}

extension ChatGroupViewController: ChatGroupDisplaying {
    func displayMessage(_ localMessage: LocalMessage) {
        let incoming = IncomingMessage(messagesViewController: self)
        let mkMessage = incoming.createMessage(localMessage: localMessage)!
        mkMessages.append(mkMessage)
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(animated: true)
    }
    
    func displayRefreshedMessages(_ localMessage: LocalMessage) {
        let incoming = IncomingMessage(messagesViewController: self)
        mkMessages.insert(incoming.createMessage(localMessage: localMessage)!, at: 0)
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(animated: true)
    }
    
    func refreshNewMessages() {
        messagesCollectionView.reloadDataAndKeepOffset()
        refreshController.endRefreshing()
    }
    
    func endRefreshing() {
        refreshController.endRefreshing()
    }
    
    func updateTypingIndicator(_ isTyping: Bool) {
        updateTypingIndicator(show: isTyping)
    }
    
    func didUpdateGroupInfo(_ groupInfo: Group) {
        let inputBar = messageInputBar as? MessageInputBarView
        let isMember = !groupInfo.removedMembersIds.contains(currentUser.id)
        stackView.isUserInteractionEnabled = isMember
        inputBar?.setupState(available: isMember)
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
    
    func audioNotGranted() {
        let alert = UIAlertController(title: Layout.Texts.accessNotGranted, message: Layout.Texts.audioAccessNotGranted, preferredStyle: .alert)
        let grantAction = UIAlertAction(title: Layout.Texts.grantAccess, style: .cancel) { _ in
            guard let appSettingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(appSettingsURL)
        }
        alert.addAction(grantAction)
        present(alert, animated: true, completion: nil)
    }
    
    func setLoading(_ show: Bool) {
        if show {
            showLoadingView()
        } else {
            dismissLoadingView()
        }
    }
}

extension ChatGroupViewController: GroupInfoUpdateProtocol {
    func didUpdateGroupInfo(dto: EditGroupDTO) {
        updateGroupInfo(dto: dto)
    }
}

//MARK: - LoadingViewDelegate
extension ChatGroupViewController: LoadingViewDelegate {
    func dismissLoadingView() {
        spinnerView.removeFromSuperview()
    }
}

//MARK: - MessageInputBarDelegate
extension ChatGroupViewController: MessageInputBarDelegate {
    func openAttachActionSheet() {
        present(attachActionSheet, animated: true)
    }
    
    func audioRecording(_ state: RecordingState) {
        interactor.audioRecording(state)
    }
}

//MARK: - Actions
@objc private extension ChatGroupViewController {
    func didTapOnContactInfo() {
        interactor.didTapOnGroupInfo()
    }
}

//MARK: - Private methods
private extension ChatGroupViewController {
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
        
        let inputBar = messageInputBar as? MessageInputBarView
        inputBar?.setupState(available: !dto.groupInfo.removedMembersIds.contains(currentUser.id))
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
    
    func updateGroupInfo(dto: EditGroupDTO) {
        titleLabel.text = dto.name
        titleViewAvatar.image = dto.avatar
        stackView.layoutIfNeeded()
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
