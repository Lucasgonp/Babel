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

final class RecentChatsViewController: ViewController<RecentChatsInteractorProtocol, UIView> {
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
        controller.definesPresentationContext = true
        return controller
    }()
    
    private var allRecentChats = [RecentChatModel]()
    private var filteredRecentChats = [RecentChatModel]()

//    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        interactor.loadRecentChats()
        
//        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
//            self.counter += 1
//            switch self.counter {
//            case 1:
//                print("light")
//                UIImpactFeedbackGenerator(style: .light).impactOccurred()
//            case 2:
//                print("medium")
//                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
//            case 3:
//                print("heavy")
//                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
//            case 4:
//                print("soft")
//                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
//            case 5:
//                print("rigid")
//                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
//            default:
//                self.counter = 0
//                UIImpactFeedbackGenerator().impactOccurred()
//            }
//        }
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
            let recent = searchController.isActive ? filteredRecentChats[indexPath.row] : allRecentChats[indexPath.row]
            allRecentChats.removeAll(where: { $0 == recent })
            filteredRecentChats.removeAll(where: { $0 == recent })
            tableView.deleteRows(at: [indexPath], with: .automatic)
            interactor.deleteRecentChat(recent)
        }
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
            filteredRecentChats = allRecentChats.filter({ ($0.groupName ?? $0.receiverName).lowercased().contains(searchText.lowercased()) })
        } else {
            filteredRecentChats = allRecentChats
        }
        
        tableView.reloadData()
    }
    
    func didTapOnChat(_ chat: RecentChatModel) {
        interactor.didTapOnChat(chat)
    }
}

@objc private extension RecentChatsViewController {
    func didTapOnNewChat() {
        interactor.didTapOnNewChat()
    }
}
