import UIKit
import DesignKit
import GalleryKit

protocol ContactInfoDisplaying: AnyObject {
    func displayViewState(_ state: ContactInfoViewState)
}

enum ContactInfoViewState {
    case success(contact: User, shouldDisplayStartChat: Bool)
    case error(message: String)
    case setLoading(isLoading: Bool)
}

private extension ContactInfoViewController.Layout {
    // example
    enum Size {
        static let imageHeight: CGFloat = 90.0
    }
}

final class ContactInfoViewController: ViewController<ContactInfoInteracting, UIView> {
    fileprivate enum Layout { }
    typealias Localizable = Strings.ContactInfo
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(cellType: ContactInfoHeaderCell.self)
        tableView.register(cellType: SettingsButtonCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    private lazy var galleryController = GalleryController(configuration: .avatarPhoto)
    
    weak var delegate: SettingsViewDelegate?
    
    private var contactUser: User?
    private var shouldDisplayStartChat = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.loadContactInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }

    override func buildViewHierarchy() {
        view.fillWithSubview(subview: tableView, navigationSafeArea: true)
    }
    
    override func setupConstraints() {
        // template
    }

    override func configureViews() {
        let backButton = UIBarButtonItem(title: String(), style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        title = Localizable.title
        view.backgroundColor = Color.backgroundPrimary.uiColor
    }
}

// MARK: - ContactInfoDisplaying
extension ContactInfoViewController: ContactInfoDisplaying {
    func displayViewState(_ state: ContactInfoViewState) {
        switch state {
        case let .success(contact, shouldDisplayStartChat):
            self.contactUser = contact
            self.shouldDisplayStartChat = shouldDisplayStartChat
            tableView.reloadData()
        case let .error(message):
            showErrorAlert(message)
        case let .setLoading(isLoading):
            if isLoading {
                showLoading()
            } else {
                hideLoading()
            }
        }
    }
}

extension ContactInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            interactor.startChat()
        }
    }
}

extension ContactInfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return shouldDisplayStartChat ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let contactUser else {
            return UITableViewCell()
        }
        switch indexPath.section {
        case 0:
            let cell: ContactInfoHeaderCell = tableView.makeCell(indexPath: indexPath, selectionStyle: .none)
            cell.render(contactUser)
            cell.delegate = self
            return cell
        case 1:
            let cell: SettingsButtonCell = tableView.makeCell(indexPath: indexPath, accessoryType: .disclosureIndicator)
            let image = ImageAsset.Image(systemName: "bubble.left.fill")?
                .withTintColor(Color.primary500.uiColor)  ?? UIImage()
            cell.render(.init(icon: image, text: "Start chat"))
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension ContactInfoViewController: ContactInfoHeaderDelegate {
    func didTapOnAvatar(_ image: UIImage) {
        let previewImageView = PreviewAvatarViewController(image: image)
        previewImageView.modalTransitionStyle = .crossDissolve
        previewImageView.modalPresentationStyle = .overFullScreen
        present(previewImageView, animated: true)
    }
}
