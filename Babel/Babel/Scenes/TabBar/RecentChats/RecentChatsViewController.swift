import UIKit
import DesignKit

protocol RecentChatsDisplaying: AnyObject {
    func displayViewState(_ state: RecentChatsViewState)
}

enum RecentChatsViewState {
    case success(recentChats: [RecentChatModel])
    case error
    case loading(isLoading: Bool)
}

private extension RecentChatsViewController.Layout {
    // example
    enum Size {
        static let imageHeight: CGFloat = 90.0
    }
}

final class RecentChatsViewController: ViewController<RecentChatsInteracting, UIView> {
    fileprivate enum Layout { 
        // template
    }
    
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
        controller.searchBar.placeholder = "Search user"
        controller.searchResultsUpdater = self
        return controller
    }()
    
    private var allRecentChats = [RecentChatModel]()
    private var filteredRecentChats = [RecentChatModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        interactor.loadRecentChats()
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
        definesPresentationContext = true
    }
}

// MARK: - RecentChatsDisplaying
extension RecentChatsViewController: RecentChatsDisplaying {
    func displayViewState(_ state: RecentChatsViewState) {
        switch state {
        case .success(let recentChats):
            allRecentChats = recentChats
            tableView.reloadData()
        case .error:
            // TODO:
            return
        case .loading(let isLoading):
            // TODO:
            return
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
    }
}

extension RecentChatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return searchController.isActive ? "Search for user" : nil
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
            filteredRecentChats = allRecentChats.filter({ $0.receiverName.lowercased().contains(searchText.lowercased()) })
        } else {
            filteredRecentChats = allRecentChats
        }
        
        tableView.reloadData()
    }
}
