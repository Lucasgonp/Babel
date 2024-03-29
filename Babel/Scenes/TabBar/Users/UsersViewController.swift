import UIKit
import DesignKit

enum UsersViewState {
    case success(users: [User])
    case error(message: String)
    case loading(isLoading: Bool)
}

protocol UsersDisplaying: AnyObject {
    func displayViewState(_ state: UsersViewState)
}

private extension UsersViewController.Layout {
    enum Texts {
        static let search = Strings.Commons.search.localized()
    }
}

final class UsersViewController: ViewController<UsersInteractorProtocol, UIView> {
    fileprivate enum Layout { }
    
    private struct Section {
        let letter : String
        let contacts : [User]
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(cellType: UserCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = Layout.Texts.search
        controller.searchResultsUpdater = self
        controller.definesPresentationContext = true
        return controller
    }()
    
    private var sections = [Section]()
    private var allContacts = [User]()
    private var filteredContacts = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.loadAllUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func buildViewHierarchy() {
        view.fillWithSubview(subview: tableView)
    }
    
    override func configureViews() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - UsersDisplaying
extension UsersViewController: UsersDisplaying {
    func displayViewState(_ state: UsersViewState) {
        switch state {
        case .success(let users):
            allContacts = users.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
            setupContactsList()
        case .error(let message):
            showErrorAlert(message)
        case .loading(let isLoading):
            if isLoading {
                showLoading()
            } else {
                hideLoading()
            }
            return
        }
    }
}

extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if searchController.isActive {
            let contact = filteredContacts[indexPath.row]
            let viewController = ContactInfoFactory.make(contactInfo: contact, shouldDisplayStartChat: true)
            viewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(viewController, animated: true)
        } else {
            let section = sections[indexPath.section]
            let contact = section.contacts[indexPath.row]
            let viewController = ContactInfoFactory.make(contactInfo: contact, shouldDisplayStartChat: true)
            viewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
}

extension UsersViewController: UITableViewDataSource {
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
            return sections[section].contacts.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return searchController.isActive ? Layout.Texts.search : sections[section].letter
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserCell = tableView.makeCell(indexPath: indexPath)
        
        if searchController.isActive {
            if let text = searchController.searchBar.text, !text.isEmpty {
                let contacts = filteredContacts.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
                let contact = contacts[indexPath.row]
                cell.render(contact)
                return cell
            } else {
                let contact = allContacts[indexPath.row]
                cell.render(contact)
                return cell
            }
        } else {
            let section = sections[indexPath.section]
            let contact = section.contacts[indexPath.row]
            cell.render(contact)
            return cell
        }
    }
}

extension UsersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? String()
        filterContentForSearchText(searchText: text)
    }
}

private extension UsersViewController {
    func setupContactsList() {
        let names = allContacts.compactMap({ $0 })
        let groupedDictionary = Dictionary(grouping: names, by: { $0.name.lowercased().prefix(1) })
        let keys = groupedDictionary.keys.sorted()
        sections = keys.map{
            Section(
                letter: String($0),
                contacts: groupedDictionary[$0]!.sorted(by: { $0.name.lowercased() < $1.name.lowercased()
            }))
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func filterContentForSearchText(searchText: String) {
        if !searchText.isEmpty {
            filteredContacts = allContacts.filter({ $0.name.lowercased().contains(searchText.lowercased()) })
        } else {
            filteredContacts = allContacts
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

@objc private extension UsersViewController {
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height - 90, right: 0)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = .zero
    }
}
