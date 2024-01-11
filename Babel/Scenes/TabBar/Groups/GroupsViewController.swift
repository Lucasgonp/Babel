import UIKit
import DesignKit

protocol GroupsDisplaying: AnyObject {
    func displaySomething()
}

final class GroupsViewController: ViewController<GroupsInteracting, UIView> {
    private struct Section {
        let letter : String
        let groups : [Group]
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(cellType: GroupCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search group"
        controller.searchResultsUpdater = self
        controller.definesPresentationContext = true
        return controller
    }()
    
    private var sections = [Section]()
    private var allGroups = [
        Group(
            name: "Grupo 1",
            status: "receiverName",
            avatarLink: "lastMassage"
        ),
        Group(
            name: "Grupo 2",
            status: "receiverName",
            avatarLink: "lastMassage"
        ),
        Group(
            name: "Grupo 3",
            status: "receiverName",
            avatarLink: "lastMassage"
        )
    ]
    
    private var filteredGroups = [Group]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor.loadAllGroups()
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
        
        allGroups.sort(by: { $0.name.lowercased() < $1.name.lowercased() })
        setupGroupsList()
        
        let newGroupButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapOnNewGroup))
        navigationItem.setRightBarButton(newGroupButton, animated: true)
    }
    
}

extension GroupsViewController: GroupsDisplaying {
    func displaySomething() {
        // template
    }
}

extension GroupsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? String()
        filterContentForSearchText(searchText: text)
    }
}

extension GroupsViewController: UITableViewDelegate {
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        tableView.deselectRow(at: indexPath, animated: true)
    //        let chat = searchController.isActive ? filteredRecentChats[indexPath.row] : allRecentChats[indexPath.row]
    //        didTapOnChat(chat)
    //    }
    //
    //    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    //        return true
    //    }
    //
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            let recent = searchController.isActive ? filteredRecentChats[indexPath.row] : allRecentChats[indexPath.row]
    //            allRecentChats.removeAll(where: { $0 == recent })
    //            filteredRecentChats.removeAll(where: { $0 == recent })
    //            tableView.deleteRows(at: [indexPath], with: .automatic)
    //            interactor.deleteRecentChat(recent)
    //        }
    //    }
}

extension GroupsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchController.isActive ? 1 : sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            if let text = searchController.searchBar.text, text.isEmpty {
                return allGroups.count
            } else {
                return filteredGroups.count
            }
        } else {
            return sections[section].groups.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return searchController.isActive ? searchController.searchBar.text : sections[section].letter
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GroupCell = tableView.makeCell(indexPath: indexPath)
        if searchController.isActive {
            if let text = searchController.searchBar.text, !text.isEmpty {
                let contacts = filteredGroups.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
                let contact = contacts[indexPath.row]
                cell.render(contact)
                return cell
            } else {
                let contact = allGroups[indexPath.row]
                cell.render(contact)
                return cell
            }
        }
        
        let section = sections[indexPath.section]
        let contact = section.groups[indexPath.row]
        cell.render(contact)
        return cell
    }
}

private extension GroupsViewController {
    func setupGroupsList() {
        let names = allGroups.compactMap({ $0 })
        let groupedDictionary = Dictionary(grouping: names, by: { $0.name.lowercased().prefix(1) })
        let keys = groupedDictionary.keys.sorted()
        sections = keys.map{
            Section(
                letter: String($0),
                groups: groupedDictionary[$0]!.sorted(by: { $0.name.lowercased() < $1.name.lowercased()
            }))
        }
        
        tableView.reloadData()
    }
    
    func filterContentForSearchText(searchText: String) {
        if !searchText.isEmpty {
            filteredGroups = allGroups.filter({ $0.name.lowercased().contains(searchText.lowercased()) })
        } else {
            filteredGroups = allGroups
        }
        
        tableView.reloadData()
    }
    
    func didTapOnChat(_ chat: RecentChatModel) {
//        interactor.didTapOnChat(chat)
    }
}

@objc private extension GroupsViewController {
    func didTapOnNewGroup() {
        let createGroup = CreateGroupFactory.make()
        createGroup.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(createGroup, animated: true)
    }
}

