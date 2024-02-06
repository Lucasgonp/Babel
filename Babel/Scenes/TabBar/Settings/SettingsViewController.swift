import UIKit
import DesignKit

enum SettingsViewState {
    case success(user: User)
    case loading(isLoading: Bool)
    case error(message: String)
}

protocol SettingsViewDelegate: AnyObject {
    func updateAvatar(image: UIImage)
}

protocol SettingsDisplaying: AnyObject {
    func displayViewState(_ state: SettingsViewState)
}

private extension SettingsViewController.Layout {
    enum Texts {
        static let title = Strings.TabBar.Settings.title.localized()
        static let tellAFriendTitle = Strings.Settings.TellAFriend.title.localized()
        static let termsAndConditionsTitle = Strings.TermsAndConditions.title.localized()
        static let systemSettings = Strings.SystemSettings.title.localized()
        static let version = Strings.Settings.version.localized()
    }
}

final class SettingsViewController: ViewController<SettingsInteractorProtocol, UIView> {
    fileprivate enum Layout { }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(cellType: SettingsUserInfoCell.self)
        tableView.register(cellType: SettingsButtonCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        return tableView
    }()
    
    private lazy var settingsButtons = [
        SettingsButtonViewModel(
            icon: UIImage(systemName: "heart.fill")?.withRenderingMode(.alwaysOriginal).withTintColor(Color.warning500.uiColor) ?? UIImage(),
            text: Layout.Texts.tellAFriendTitle,
            completionHandler: { [weak self] in
                self?.interactor.tellAFriend()
            }
        ),
        SettingsButtonViewModel(
            icon: UIImage(systemName: "info.square.fill") ?? UIImage(),
            text: Layout.Texts.termsAndConditionsTitle,
            completionHandler: { [weak self] in
                self?.interactor.termsAndConditions()
            }
        ),
        SettingsButtonViewModel(
            icon: UIImage(systemName: "gear")?.withRenderingMode(.alwaysOriginal).withTintColor(Color.grayscale300.uiColor) ?? UIImage(),
            text: Layout.Texts.systemSettings,
            completionHandler: { [weak self] in
                self?.interactor.systemSettings()
            }
        )
    ]
    
    private var userInfoCell: SettingsUserInfoCell?
    private var currentUser: User?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.loadSettings()
        
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func buildViewHierarchy() { 
        view.fillWithSubview(subview: tableView)
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

extension SettingsViewController: SettingsViewDelegate {
    func updateAvatar(image: UIImage) {
        userInfoCell?.updateAvatar(image: image)
    }
}

extension SettingsViewController: SystemSettingsDelegate {
    func didTapOnLogout() {
        interactor.logout()
    }
}

private extension SettingsViewController {
    func displaySettings(for user: User) {
        currentUser = user
        tableView.reloadData()
        tableView.isHidden = false
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let _ = cell as? SettingsUserInfoCell {
            interactor.editProfile()
        } else if let cell = cell as? SettingsButtonCell {
            cell.completionHandler?()
        }
    }
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return settingsButtons.count
        default:
            return .zero
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentUser else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case 0:
            let cell: SettingsUserInfoCell = tableView.makeCell(indexPath: indexPath, accessoryType: .disclosureIndicator)
            cell.render(currentUser)
            userInfoCell = cell
            return cell
        case 1:
            let cell: SettingsButtonCell = tableView.makeCell(indexPath: indexPath, accessoryType: .disclosureIndicator)
            cell.render(settingsButtons[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? String()
        return (section == 2) ? "\(Layout.Texts.version) \(version)" : nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        (view as? UITableViewHeaderFooterView)?.textLabel?.textAlignment = .center
    }
}
