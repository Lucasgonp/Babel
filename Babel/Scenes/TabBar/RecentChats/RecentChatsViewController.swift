import UIKit
import DesignKit
import StorageKit

protocol RecentChatsDisplaying: AnyObject {
    func displayViewState(_ state: RecentChatsViewState)
}

enum RecentChatsViewState {
    case success(recentChats: [RecentChatModel])
    case error
    case loading(isLoading: Bool)
}

private extension RecentChatsViewController.Layout {
    enum Texts {
        static let search = Strings.Commons.search.localized()
        static let deleteTitle = Strings.RecentChat.ActionSheet.Delete.title.localized()
        static let deleteDescription = Strings.RecentChat.ActionSheet.Delete.description.localized()
        static let cancel = Strings.Commons.cancel.localized()
    }
}

final class RecentChatsViewController: ViewController<RecentChatsInteractorProtocol, UIView> {
    fileprivate enum Layout { }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(cellType: RecentChatCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
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
    
    private var allRecentChats = [RecentChatModel]()
    private var filteredRecentChats = [RecentChatModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.loadRecentChats()
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
        
        let newChatButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapOnNewChat))
        navigationItem.setRightBarButton(newChatButton, animated: true)
    }
}

// MARK: - RecentChatsDisplaying
extension RecentChatsViewController: RecentChatsDisplaying {
    func displayViewState(_ state: RecentChatsViewState) {
        switch state {
        case .success(let recentChats):
            allRecentChats = recentChats
            tableView.reloadData()
            
            if let recentChatToPush: RecentChatModel = StorageLocal.shared.getStorageObject(for: kWAITPUSHCHAT) {
                StorageLocal.shared.removeStorage(key: kWAITPUSHCHAT)
                interactor.didTapOnChat(recentChatToPush)
            }
        case .error:
            // TODO:
            return
        case .loading(let isLoading):
            if isLoading {
                showLoading()
            } else {
                hideLoading()
            }
        }
    }
}

extension RecentChatsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? String()
        filterContentForSearchText(searchText: text)
    }
}

extension RecentChatsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chat = searchController.isActive ? filteredRecentChats[indexPath.row] : allRecentChats[indexPath.row]
        didTapOnChat(chat)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            makeDeleteRecentActionSheet(indexPath: indexPath)
        }
    }
}

extension RecentChatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return searchController.isActive ? Layout.Texts.search : nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredRecentChats.count : allRecentChats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RecentChatCell = tableView.makeCell(indexPath: indexPath)
        if searchController.isActive {
            cell.render(dto: filteredRecentChats[indexPath.row])
        } else {
            cell.render(dto: allRecentChats[indexPath.row])
        }
        return cell
    }
}

private extension RecentChatsViewController {
    func filterContentForSearchText(searchText: String) {
        if !searchText.isEmpty {
            filteredRecentChats = allRecentChats.filter({ ($0.groupName ?? $0.receiverName).lowercased().contains(searchText.lowercased()) })
        } else {
            filteredRecentChats = allRecentChats
        }
        
        tableView.reloadData()
    }
    
    func didTapOnChat(_ chat: RecentChatModel) {
        interactor.didTapOnChat(chat)
    }
    
    func makeDeleteRecentActionSheet(indexPath: IndexPath) {
        let deleteRecentAction = UIAlertAction(title: Layout.Texts.deleteTitle, style: .destructive, handler: { [weak self] _ in
            self?.navigationController?.popViewController(completion: { [weak self] _ in
                self?.makeDeleteRecentAction(indexPath: indexPath)
            })
        })
        let actionSheet = UIAlertController(title: Layout.Texts.deleteTitle, message: Layout.Texts.deleteDescription, preferredStyle: .alert)
        actionSheet.addAction(deleteRecentAction)
        actionSheet.addAction(UIAlertAction(title: Layout.Texts.cancel, style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    
    func makeDeleteRecentAction(indexPath: IndexPath) {
        let recent = searchController.isActive ? filteredRecentChats[indexPath.row] : allRecentChats[indexPath.row]
        allRecentChats.removeAll(where: { $0 == recent })
        filteredRecentChats.removeAll(where: { $0 == recent })
        tableView.deleteRows(at: [indexPath], with: .automatic)
        interactor.deleteRecentChat(recent)
    }
}

@objc private extension RecentChatsViewController {
    func didTapOnNewChat() {
        interactor.didTapOnNewChat()
    }
}
