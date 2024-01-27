import UIKit
import DesignKit
import Contacts
import MessageUI

enum TellAFriendViewState {
    case success(contacts: [CNContact])
    case accessNotGranted
    case error(message: String)
    case loading(isLoading: Bool)
}

protocol TellAFriendDisplaying: AnyObject {
    func displayViewState(_ state: TellAFriendViewState)
}

private extension TellAFriendViewController.Layout {
    enum Texts {
        static let title = Strings.Settings.TellAFriend.title.localized()
        static let search = Strings.Commons.search.localized()
        static let accessNotGranted = Strings.Commons.accessNotGranted.localized()
        static let grantAccess = Strings.Commons.grantAccess.localized()
        static let accessContactsMessage = Strings.TellAFriend.accessContactsMessage.localized()
        static let shareInviteLink = Strings.TellAFriend.shareInviteLink.localized()
    }
}

final class TellAFriendViewController: ViewController<TellAFriendInteractorProtocol, UIView> {
    fileprivate enum Layout { }
    
    private struct Section {
        let letter : String
        let contacts : [PhoneContactModel]
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(cellType: UITableViewCell.self)
        tableView.register(cellType: TellAFriendCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = Layout.Texts.search
        controller.searchResultsUpdater = self
        controller.definesPresentationContext = true
        return controller
    }()
    
    private var sections = [Section]()
    private var allContacts = [PhoneContactModel]()
    private var filteredContacts = [PhoneContactModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.fetchContacts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func buildViewHierarchy() {
        view.fillWithSubview(subview: tableView)
    }
    
    override func configureViews() {
        title = Layout.Texts.title
        view.backgroundColor = Color.backgroundPrimary.uiColor
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension TellAFriendViewController: TellAFriendDisplaying {
    func displayViewState(_ state: TellAFriendViewState) {
        
        switch state {
        case let .success(contacts):
            let filteredContacts = contacts.filter({ !$0.phoneNumbers.isEmpty && !$0.givenName.isEmpty })
            let users = filteredContacts.compactMap({ PhoneContactModel(
                firstName: $0.givenName,
                middleName: $0.middleName,
                lastName: $0.familyName,
                phoneNumbers: $0.phoneNumbers,
                imageData: $0.imageData
            )})
            allContacts = users.sorted(by: { $0.fullName.lowercased() < $1.fullName.lowercased() })
            setupContactsList()
        case .accessNotGranted:
            navigationController?.popViewController(completion: { [weak self] _ in
                self?.showMessageAlert(title: Layout.Texts.accessNotGranted, message: Layout.Texts.accessContactsMessage, button: Layout.Texts.grantAccess) { _ in
                    let appSettingsURL = URL(string: UIApplication.openSettingsURLString)!
                    UIApplication.shared.open(appSettingsURL)
                }
            })
        case let .error(message):
            showErrorAlert(message)
        case let .loading(isLoading):
            if isLoading {
                showLoading()
            } else {
                hideLoading()
            }
        }
    }
}

extension TellAFriendViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let messsage = RemoteConfigManager.shared.shareAppMessage
//        let image = Image.babelBrandLogo.image
        
        if searchController.isActive {
            let contact = filteredContacts[indexPath.row]
            openExternalMessageApp(for: contact, message: messsage, image: nil)
        } else {
            if indexPath.section == 0 {
                let sharedObjects: [AnyObject] = [messsage as AnyObject]
                let activityViewController = UIActivityViewController(activityItems: sharedObjects, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = view
                
                DispatchQueue.main.async {
                    self.present(activityViewController, animated: true, completion: nil)
                }
            } else {
                let section = sections[indexPath.section - 1]
                let contact = section.contacts[indexPath.row]
                openExternalMessageApp(for: contact, message: messsage, image: nil)
            }
        }
        
    }
}

extension TellAFriendViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchController.isActive ? 1 : sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            if let text = searchController.searchBar.text, text.isEmpty {
                return allContacts.count
            } else {
                return filteredContacts.count
            }
        } else {
            return section == 0 ? 1 : sections[section - 1].contacts.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return searchController.isActive ? Layout.Texts.search : (section == 0 ? nil : sections[section - 1].letter)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TellAFriendCell = tableView.makeCell(indexPath: indexPath)
        
        if searchController.isActive {
            if let text = searchController.searchBar.text, !text.isEmpty {
                let contacts = filteredContacts.sorted(by: { $0.fullName.lowercased() < $1.fullName.lowercased() })
                let contact = contacts[indexPath.row]
                cell.render(contact)
                return cell
            } else {
                let contact = allContacts[indexPath.row]
                cell.render(contact)
                return cell
            }
        } else {
            if indexPath.section == 0 && indexPath.row == 0 {
                let cell: UITableViewCell = tableView.makeCell(indexPath: indexPath)
                var content = cell.defaultContentConfiguration()
                content.text = Layout.Texts.shareInviteLink
                content.image = UIImage(systemName: "square.and.arrow.up.circle.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 26)).withTintColor(Color.blueNative.uiColor)
                content.imageToTextPadding = 17
                content.imageProperties.reservedLayoutSize = CGSize(width: 42, height: 42)
                content.textProperties.color = Color.blueNative.uiColor
                cell.contentConfiguration = content
                return cell
            }
            
            let section = sections[indexPath.section - 1]
            let contact = section.contacts[indexPath.row]
            cell.render(contact)
            return cell
        }
    }
}

extension TellAFriendViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? String()
        filterContentForSearchText(searchText: text)
    }
}

extension TellAFriendViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true)
    }
}

private extension TellAFriendViewController {
    func setupContactsList() {
        let names = allContacts.compactMap({ $0 })
        let groupedDictionary = Dictionary(grouping: names, by: { $0.fullName.lowercased().prefix(1) })
        let keys = groupedDictionary.keys.sorted()
        sections = keys.map{
            Section(
                letter: String($0),
                contacts: groupedDictionary[$0]!.sorted(by: { $0.fullName.lowercased() < $1.fullName.lowercased()
            }))
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func filterContentForSearchText(searchText: String) {
        if !searchText.isEmpty {
            filteredContacts = allContacts.filter({ $0.fullName.lowercased().contains(searchText.lowercased()) })
        } else {
            filteredContacts = allContacts
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func openExternalMessageApp(for model: PhoneContactModel, message: String, image: UIImage?) {
        let iMessageController = MFMessageComposeViewController()
        iMessageController.body = message
        iMessageController.recipients = [model.phoneNumber]
        iMessageController.messageComposeDelegate = self
        
        if let image, let data = image.pngData() {
            iMessageController.addAttachmentData(data, typeIdentifier: "babel.logo", filename: "babel.logo.png")
        }
        
        DispatchQueue.main.async {
            self.present(iMessageController, animated: true)
        }
    }
}

@objc private extension TellAFriendViewController {
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height - 90, right: 0)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = .zero
    }
}
