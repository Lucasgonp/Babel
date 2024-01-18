import UIKit
import DesignKit

enum AddMembersViewState {
    case success(users: [User])
    case error(message: String)
    case loading(isLoading: Bool)
}

protocol AddMembersDisplaying: AnyObject {
    func displayViewState(_ state: AddMembersViewState)
}

final class AddMembersViewController: ViewController<AddMembersInteractorProtocol, UIView> {
    private struct Section {
        let letter : String
        let users : [User]
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
        controller.searchBar.placeholder = Strings.Commons.searchUser
        controller.searchResultsUpdater = self
        controller.definesPresentationContext = true
        return controller
    }()
    
    private lazy var addButton: UIBarButtonItem = {
        let item = UIBarButtonItem(title: Strings.Commons.add, style: .done, target: self, action: #selector(didTapDoneButton))
        item.isEnabled = false
        return item
    }()
    
    private var sections = [Section]()
    private var allUsers = [User]()
    private var filteredUsers = [User]()
    private var selectedUsers = [User]()
    
    var completion: (([User]) -> Void)?
    
    private let groupMembers: [User]
    
    init(interactor: AddMembersInteractor, groupMembers: [User]) {
        self.groupMembers = groupMembers
        super.init(interactor: interactor)
    }
    
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
        view.backgroundColor = Color.backgroundSecondary.uiColor
        
        configureNavigation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

extension AddMembersViewController: AddMembersDisplaying {
    func displayViewState(_ state: AddMembersViewState) {
        switch state {
        case .success(let users):
            let users = users.filter({ !groupMembers.contains($0) })
            allUsers = users.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
            setupUsersList()
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

extension AddMembersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let user: User
        if searchController.isActive {
            user = filteredUsers[indexPath.row]
        } else {
            let section = sections[indexPath.section]
            user = section.users[indexPath.row]
        }
        
        if selectedUsers.contains(user) {
            selectedUsers.removeAll(where: { $0 == user })
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            selectedUsers.append(user)
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        checkAddButtonState()
    }
}

extension AddMembersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchController.isActive ? 1 : sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            if let text = searchController.searchBar.text, text.isEmpty {
                return allUsers.count
            } else {
                return filteredUsers.count
            }
        } else {
            return sections[section].users.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return searchController.isActive ? Strings.Commons.users : sections[section].letter
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserCell = tableView.makeCell(indexPath: indexPath)
        
        if searchController.isActive {
            if let text = searchController.searchBar.text, !text.isEmpty {
                let users = filteredUsers.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
                let user = users[indexPath.row]
                cell.render(user)
                cell.accessoryType = selectedUsers.contains(user) ? .checkmark : .none
                return cell
            } else {
                let user = allUsers[indexPath.row]
                cell.render(user)
                cell.accessoryType = selectedUsers.contains(user) ? .checkmark : .none
                return cell
            }
        } else {
            let section = sections[indexPath.section]
            let user = section.users[indexPath.row]
            cell.render(user)
            cell.accessoryType = selectedUsers.contains(user) ? .checkmark : .none
            return cell
        }
    }
}

extension AddMembersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? String()
        filterContentForSearchText(searchText: text)
    }
}

private extension AddMembersViewController {
    func configureNavigation() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        navigationItem.setRightBarButton(addButton, animated: false)
        
        let cancel = UIBarButtonItem(title: Strings.Commons.cancel, style: .plain, target: self, action: #selector(didTapCancelButton))
        navigationItem.setLeftBarButton(cancel, animated: true)
    }
    
    func checkAddButtonState() {
        navigationItem.rightBarButtonItem?.isEnabled = selectedUsers.count > 0
    }
    
    func setupUsersList() {
        let names = allUsers.compactMap({ $0 })
        let groupedDictionary = Dictionary(grouping: names, by: { $0.name.lowercased().prefix(1) })
        let keys = groupedDictionary.keys.sorted()
        sections = keys.map{
            Section(
                letter: String($0),
                users: groupedDictionary[$0]!.sorted(by: { $0.name.lowercased() < $1.name.lowercased()
            }))
        }
        
        tableView.reloadData()
    }
    
    func filterContentForSearchText(searchText: String) {
        if !searchText.isEmpty {
            filteredUsers = allUsers.filter({ $0.name.lowercased().contains(searchText.lowercased()) })
        } else {
            filteredUsers = allUsers
        }
        
        tableView.reloadData()
    }
}

@objc private extension AddMembersViewController {
    func didTapDoneButton() {
        view.endEditing(true)
        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.completion?(self.selectedUsers)
            self.selectedUsers = []
        }
    }
    
    func didTapCancelButton() {
        view.endEditing(true)
        dismiss(animated: true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height - 90, right: 0)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = .zero
    }
}

