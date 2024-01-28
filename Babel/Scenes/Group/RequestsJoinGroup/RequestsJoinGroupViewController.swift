import UIKit
import DesignKit

protocol RequestsJoinGroupDisplaying: AnyObject {
    func displayUsers(_ users: [User])
    func updateRequests(_ id: String)
    func displayError(message: String)
}

private extension RequestsJoinGroupViewController.Layout {
    enum Texts {
        static let title = Strings.GroupInfo.requestToJoin.localized()
        static let accept = Strings.GroupInfo.ActionSheet.accept.localized()
        static let acceptQuestion = Strings.GroupInfo.ActionSheet.acceptQuestion.localized()
        static let deny = Strings.GroupInfo.ActionSheet.deny.localized()
        static let denyQuestion = Strings.GroupInfo.ActionSheet.denyQuestion.localized()
    }
}

final class RequestsJoinGroupViewController: ViewController<RequestsJoinGroupInteractorProtocol, UIView> {
    fileprivate enum Layout { }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(cellType: RequestsJoinGroupCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    private var users = [User]()
    
    private var removedUsersIdsFromList = [String]()
    
    private var completionHandler: (() -> Void)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.fetchRequests()
    }
    
    override func buildViewHierarchy() {
        view.fillWithSubview(subview: tableView)
    }

    override func configureViews() { 
        title = Layout.Texts.title
    }
}

extension RequestsJoinGroupViewController: RequestsJoinGroupDisplaying {
    func displayUsers(_ users: [User]) {
        self.users = users
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func updateRequests(_ id: String) {
        if let completionHandler {
            completionHandler()
        } else {
            completionHandler = { [weak self] in
                self?.removeRequestFromList(id: id)
            }
        }
    }
    
    func displayError(message: String) {
        showErrorAlert(message)
    }
}

extension RequestsJoinGroupViewController: RequestsJoinGroupCellDelegate {
    func didTapApprove(id: String, completion: @escaping (Bool) -> Void) {
        makeActionSheet(title: Layout.Texts.accept, description: Layout.Texts.acceptQuestion, button: Layout.Texts.accept) { [weak self] didAccept in
            completion(didAccept)
            self?.interactor.approveUser(id: id)
        }
    }
    
    func didTapDeny(id: String, completion: @escaping (Bool) -> Void) {
        makeActionSheet(title: Layout.Texts.deny, description: Layout.Texts.denyQuestion, button: Layout.Texts.deny) { [weak self] didAccept in
            completion(didAccept)
            self?.interactor.denyUser(id: id)
        }
    }
    
    func didFinishAnimation(id: String) {
        if let completionHandler {
            completionHandler()
        } else {
            completionHandler = { [weak self] in
                self?.removeRequestFromList(id: id)
            }
        }
    }
}

extension RequestsJoinGroupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension RequestsJoinGroupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RequestsJoinGroupCell = tableView.makeCell(indexPath: indexPath)
        let user = users[indexPath.row]
        cell.render(name: user.name, description: user.status, avatarLink: user.avatarLink, id: user.id)
        cell.delegate = self
        return cell
    }
}

private extension RequestsJoinGroupViewController {
    func makeActionSheet(title: String, description: String, button: String, completion: @escaping (Bool) -> Void) {
        let alertAction = UIAlertAction(title: button, style: .default, handler: { _ in
            completion(true)
        })
        let cancelAction = UIAlertAction(title: Strings.Commons.cancel, style: .cancel) { _ in
            completion(false)
        }
        
        let actionSheet = UIAlertController(title: title, message: description, preferredStyle: .alert)
        actionSheet.addAction(alertAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
    
    func removeRequestFromList(id: String) {
        let requestsCell = tableView.visibleCells as? [RequestsJoinGroupCell]
        guard let cell = requestsCell?.first(where: { $0.userId == id }), let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        users.remove(at: indexPath.row)
        DispatchQueue.main.async {
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
