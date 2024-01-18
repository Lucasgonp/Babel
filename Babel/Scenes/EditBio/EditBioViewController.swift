import UIKit
import DesignKit

protocol EditBioDisplaying: AnyObject {
    func displayErrorMessage(message: String)
}

final class EditBioViewController: ViewController<EditBioInteractorProtocol, UIView> {
    typealias Localizable = Strings.UserBio
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(cellType: UITableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        return tableView
    }()
    
    private lazy var aboutTextField: TextField = {
        let textField = TextField()
        textField.render(.simple(placeholder: Localizable.placeholder, textLength: 35))
        textField.returnKeyType = .done
        textField.enablesReturnKeyAutomatically = true
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let standardBios = UserBio.allCases
    private var currentUser: User? {
        AccountInfo.shared.user
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }

    override func buildViewHierarchy() { 
        view.fillWithSubview(subview: tableView)
    }
    
    override func setupConstraints() { 
        // template
    }

    override func configureViews() { 
        title = Localizable.title
        view.backgroundColor = Color.backgroundPrimary.uiColor
        configureNavigation()
    }
}

// MARK: - EditBioDisplaying
extension EditBioViewController: EditBioDisplaying {
    func displayErrorMessage(message: String) {
        showErrorAlert(message)
    }
}

extension EditBioViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            let config = tableView.cellForRow(at: indexPath)?.contentConfiguration as? UIListContentConfiguration
            aboutTextField.text = config?.text ?? aboutTextField.text
            
            if var currentUser {
                currentUser.status = config?.text ?? aboutTextField.text
                interactor.saveUserToFirebase(user: currentUser)
            }
        }
    }
}

extension EditBioViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return standardBios.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let currentUser else {
            return UITableViewCell()
        }
        
        if indexPath.section == 0 {
            let cell: UITableViewCell = tableView.makeCell(indexPath: indexPath, selectionStyle: .none)
            aboutTextField.text = currentUser.status
            cell.contentView.fillWithSubview(subview: aboutTextField, spacing: .init(top: 2, left: 4, bottom: 2, right: 4))
            return cell
        } else {
            let cell: UITableViewCell = tableView.makeCell(indexPath: indexPath, accessoryType: .disclosureIndicator)
            var content = cell.defaultContentConfiguration()
            content.text = standardBios[indexPath.row].rawValue
            cell.contentConfiguration = content
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return Localizable.currentTitle
        } else {
            return Localizable.optionsTitle
        }
    }
}

@objc private extension EditBioViewController {
    func didTapDoneButton() {
        view.endEditing(true)
        
        guard var currentUser else {
            return
        }
        currentUser.status = aboutTextField.text
        interactor.saveUserToFirebase(user: currentUser)
    }
}

private extension EditBioViewController {
    func configureNavigation() {
        let done = UIBarButtonItem(title: Strings.Commons.done, style: .done, target: self, action: #selector(didTapDoneButton))
        navigationItem.setRightBarButton(done, animated: true)
        updateDoneBarButton(isHidden: true)
    }
    
    func updateDoneBarButton(isEnabled: Bool) {
        navigationItem.rightBarButtonItem?.isEnabled = isEnabled
    }
    
    func updateDoneBarButton(isHidden: Bool) {
        // TODO: Check if is hiding correctly
        if isHidden {
            navigationItem.rightBarButtonItem = nil
        } else {
            let done = UIBarButtonItem(title: Strings.Commons.done, style: .done, target: self, action: #selector(didTapDoneButton))
            navigationItem.rightBarButtonItem = done
        }
    }
}

extension EditBioViewController: TextFieldDelegate {
    func textFieldDidEndEditing(_ textField: TextFieldInput) {
        updateDoneBarButton(isHidden: true)
    }
    
    func textFieldDidBeginEditing(_ textField: TextFieldInput) {
        updateDoneBarButton(isHidden: false)
    }
    
    func textFieldDidChange(_ textField: TextFieldInput) {
        updateDoneBarButton(isEnabled: !aboutTextField.text.isEmpty)
    }
    
    func textFieldShouldReturn(_ textField: TextFieldInput) {
        didTapDoneButton()
    }
}
