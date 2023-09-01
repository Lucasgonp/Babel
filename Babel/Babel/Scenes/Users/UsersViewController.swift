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
    // example
    enum Size {
        static let imageHeight: CGFloat = 90.0
    }
}

final class UsersViewController: ViewController<UsersInteracting, UIView> {
    private struct Section {
        let letter : String
        let contacts : [UserContact]
    }
    
    fileprivate enum Layout {
        // template
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(cellType: UserCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var contacts: [UserContact] = []
    
    //    private let contacts: [UserContact] = [
    //        UserContact(
    //            name: "Amendoim corajoso",
    //            about: "Olá sou o amendoim corajoso",
    //            image: Image.avatarPlaceholder.image
    //        ),
    //        UserContact(
    //            name: "Leonardo Pimentel",
    //            about: "Olá estou usando o Babelzinho",
    //            image: Image.avatarPlaceholder.image
    //        ),
    //        UserContact(
    //            name: "Tayná Paulino",
    //            about: "Olá estou usando o Babelzinho",
    //            image: Image.avatarPlaceholder.image
    //        ),
    //        UserContact(
    //            name: "Goku Michael Jackson",
    //            about: "Olá estou usando o Babelzinho",
    //            image: Image.avatarPlaceholder.image
    //        ),
    //        UserContact(
    //            name: "Leonardo da Vinci",
    //            about: "Olá estou usando o Babelzinho",
    //            image: Image.avatarPlaceholder.image
    //        ),
    //        UserContact(
    //            name: "Felipe Neto",
    //            about: "Olá estou usando o Babelzinho",
    //            image: Image.avatarPlaceholder.image
    //        ),
    //        UserContact(
    //            name: "Felipe Castanhari",
    //            about: "Olá estou usando o Babelzinho",
    //            image: Image.avatarPlaceholder.image
    //        ),
    //    ]
    
    private var filteredContacts = [UserContact]()
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search user"
        controller.searchResultsUpdater = self
        return controller
    }()
    
    private var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.loadAllUsers()
    }
    
    override func buildViewHierarchy() {
        view.fillWithSubview(subview: tableView)
    }
    
    override func setupConstraints() {
        // template
    }
    
    override func configureViews() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
}

// MARK: - UsersDisplaying
extension UsersViewController: UsersDisplaying {
    func displayViewState(_ state: UsersViewState) {
        switch state {
        case .success(let users):
            self.contacts = users.compactMap({
                UserContact(
                    name: $0.name,
                    about: $0.status,
                    image: Image.avatarPlaceholder.image
                )
            })
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

private extension UsersViewController {
    func setupContactsList() {
        let names = contacts.compactMap({ $0 })
        let groupedDictionary = Dictionary(grouping: names, by: { $0.name.prefix(1) })
        let keys = groupedDictionary.keys.sorted()
        sections = keys.map{ Section(letter: String($0), contacts: groupedDictionary[$0]!.sorted()) }
        
        UIView.performWithoutAnimation { [unowned self] in
            self.tableView.reloadData()
        }
    }
}

extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UsersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchController.isActive ? 1 : sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredContacts.count : sections[section].contacts.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return searchController.isActive ? "Contacts" : sections[section].letter
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserCell = tableView.makeCell(indexPath: indexPath)
        
        if searchController.isActive {
            let contacts = filteredContacts.sorted()
            let contact = contacts[indexPath.row]
            cell.render(contact)
            return cell
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
        //
    }
}
