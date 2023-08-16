import UIKit
import DesignKit

enum LoginViewState {
    case loading(isLoading: Bool)
    case error(message: String)
}

protocol LoginDisplaying: AnyObject {
    func displayViewState(_ state: LoginViewState)
}

private extension LoginViewController.Layout {
    enum Size {
        static let imageHeight: CGFloat = 120
    }
}

final class LoginViewController: ViewController<LoginInteracting, UIView> {
    fileprivate enum Layout { }
    typealias Localizable = Strings.Login

    private lazy var brandImageView: ImageView = {
        let image = Brand.brandLogo.image
        let imageView = ImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var inputsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, primaryButton, secondaryButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var emailTextField: TextField = {
        let textField = TextField()
        textField.render(.standard(placeholder: Localizable.Field.Email.placeholder, keyboardType: .emailAddress))
        textField.validations = [EmailValidation()]
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordTextField: TextField = {
        let textField = TextField()
        textField.render(.standard(placeholder: Localizable.Field.Password.placeholder, isSecureTextEntry: true))
        textField.validations = [PasswordValidation()]
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var primaryButton: Button = {
        let button = Button()
        button.render(.primary(title: Localizable.Button.login))
        button.addTarget(self, action: #selector(primaryButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var secondaryButton: Button = {
        let button = Button()
        button.render(.secondary(title: Localizable.Button.register))
        button.addTarget(self, action: #selector(secondaryButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func buildViewHierarchy() { 
        view.addSubview(brandImageView)
        view.addSubview(inputsStackView)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            brandImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            brandImageView.heightAnchor.constraint(equalToConstant: Layout.Size.imageHeight),
            brandImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            brandImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            inputsStackView.topAnchor.constraint(equalTo: brandImageView.bottomAnchor, constant: 22),
            inputsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            inputsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    override func configureViews() {
        view.backgroundColor = Color.backgroundLogo.uiColor
        inputsStackView.setCustomSpacing(32, after: passwordTextField)
    }
}

// MARK: - LoginDisplaying
extension LoginViewController: LoginDisplaying {
    func displayViewState(_ state: LoginViewState) {
        switch state {
        case .loading(let isLoading):
            primaryButton.setLoading(isLoading)
        case .error(let message):
            showError(message)
        }
    }
}

@objc private extension LoginViewController {
    func primaryButtonAction() {
        let isEmailValid = emailTextField.validate()
        let isPasswordValid = passwordTextField.validate()
        
        guard isEmailValid, isPasswordValid else {
            return
        }
        
        let loginModel = LoginUserModel(email: emailTextField.text, password: passwordTextField.text)
        interactor.loginWith(userModel: loginModel)
    }
    
    func secondaryButtonAction() {
        interactor.signUpAction()
    }
}

extension LoginViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
