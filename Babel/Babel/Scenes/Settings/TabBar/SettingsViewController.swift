import UIKit
import DesignKit

enum SettingsViewState {
    case success(user: User)
    case loading(isLoading: Bool)
    case error(message: String)
}

protocol SettingsDisplaying: AnyObject {
    func displayViewState(_ state: SettingsViewState)
}

private extension SettingsViewController.Layout {
    // example
    enum Size {
        static let imageHeight: CGFloat = 90.0
    }
}

final class SettingsViewController: ViewController<SettingsInteracting, UIView> {
    fileprivate enum Layout { }
    typealias Localizable = Strings.Settings
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(cellType: SettingsUserInfoCell.self)
        tableView.register(cellType: SettingsButtonCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var viewModel: SettingsViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.loadSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func buildViewHierarchy() { 
        view.fillWithSubview(subview: tableView)
    }
    
    override func setupConstraints() { 
        // template
    }

    override func configureViews() {
        // template
    }
}

// MARK: - SettingsDisplaying
extension SettingsViewController: SettingsDisplaying {
    func displayViewState(_ state: SettingsViewState) {
        switch state {
        case .success(let user):
            displaySettings(for: user)
        case .loading(let isLoading):
            if isLoading {
                showLoading()
            } else {
                hideLoading()
            }
        case .error(let message):
            showErrorAlert(message)
        }
    }
}

private extension SettingsViewController {
    func displaySettings(for user: User) {
        let buttons = [
            SettingsButtonViewModel(
                icon: Icon.heartSquareIcon.image.withTintColor(Color.warning500.uiColor, renderingMode: .alwaysOriginal),
                text: Localizable.SecondSession.tellAFriend,
                completionHandler: { [weak self] in
                    self?.interactor.tellAFriend()
                }
            ),
            SettingsButtonViewModel(
                icon: Icon.infoIcon.image,
                text: Localizable.SecondSession.termsAndConditions,
                completionHandler: { [weak self] in
                    self?.interactor.termsAndConditions()
                }
            )
        ]
        viewModel = SettingsViewModel(user: user, buttons: buttons)
        DispatchQueue.main.async { [unowned self] in
            self.tableView.reloadData()
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if let _ = cell as? SettingsUserInfoCell {
            interactor.editProfile()
        } else if let cell = cell as? SettingsButtonCell {
            cell.completionHandler?()
        } else {
            interactor.logout()
        }
    }
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return viewModel?.buttons.count ?? 2
        case 2:
            return 1
        default:
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingsUserInfoCell.identifier,
                for: indexPath
            ) as? SettingsUserInfoCell else {
                return UITableViewCell()
            }
            DispatchQueue.main.async {
                cell.render(viewModel.user)
            }
            cell.selectionStyle = .none
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingsButtonCell.identifier,
                for: indexPath
            ) as? SettingsButtonCell else {
                return UITableViewCell()
            }
            DispatchQueue.main.async {
                cell.render(viewModel.buttons[indexPath.row])
            }
            cell.selectionStyle = .none
            return cell
        case 2:
            let button = Button()
            button.setTitle("Logout", for: .normal)
            button.setTitleColor(Color.warning500.uiColor, for: .normal)
            let cell = UITableViewCell()
            cell.fillWithSubview(subview: button, spacing: .init(top: 6, left: .zero, bottom: 6, right: .zero))
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let version = Localizable.ThirdSection.version + "0.0.1"
        return (section == 2) ? version : nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        (view as? UITableViewHeaderFooterView)?.textLabel?.textAlignment = .center
    }
}
