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
        tableView.isHidden = true
        return tableView
    }()
    
    private lazy var settingsButtons = [
        SettingsButtonViewModel(
            icon: Icon.heartSquare.image.withTintColor(Color.warning500.uiColor, renderingMode: .alwaysOriginal),
            text: Localizable.SecondSession.tellAFriend,
            completionHandler: { [weak self] in
                self?.interactor.tellAFriend()
            }
        ),
        SettingsButtonViewModel(
            icon: Icon.info.image,
            text: Localizable.SecondSession.termsAndConditions,
            completionHandler: { [weak self] in
                self?.interactor.termsAndConditions()
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

extension SettingsViewController: SettingsViewDelegate {
    func updateAvatar(image: UIImage) {
        userInfoCell?.updateAvatar(image: image)
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
            return settingsButtons.count
        case 2:
            return 1
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
        case 2:
            let button = Button()
            button.setTitle("Logout", for: .normal)
            button.setTitleColor(Color.warning500.uiColor, for: .normal)
            let cell = UITableViewCell()
            cell.fillWithSubview(subview: button, spacing: .init(top: 6, left: .zero, bottom: 6, right: .zero))
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? String()
        return (section == 2) ? Localizable.ThirdSection.version + version : nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        (view as? UITableViewHeaderFooterView)?.textLabel?.textAlignment = .center
    }
}
