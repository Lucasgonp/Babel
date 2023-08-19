import UIKit
import DesignKit

enum LoginViewState {
    case loadingButton(isLoading: Bool)
    case loadingHud(isLoading: Bool)
    case error(message: String)
}

protocol LoginDisplaying: AnyObject {
    func displayViewState(_ state: LoginViewState)
    func displayResendEmail(viewModel: AlertViewModel)
    func displayResetPassword(viewModel: AlertViewModel)
    func displayFeedbackAlert(title: String, message: String)
}

private extension LoginViewController.Layout {
    enum Size {
        static let imageHeight: CGFloat = 120
    }
}

final class LoginViewController: ViewController<LoginInteracting, UIView> {
    fileprivate enum Layout { }
    typealias Localizable = Strings.Login

    private lazy var brandImageView: UIImageView = {
        let image = Image.babelBrandLogo.image
        let imageView = ImageView(image: image)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var inputsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [primaryButton, secondaryButton])
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
    
    private lazy var forgotPasswordButton: Button = {
        let button = Button()
        button.render(.tertiary(title: "**Forgot the password?**"))
        button.addTarget(self, action: #selector(forgotPasswordButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        view.addSubview(forgotPasswordButton)
        view.addSubview(buttonsStackView)
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
        
        NSLayoutConstraint.activate([
            forgotPasswordButton.topAnchor.constraint(equalTo: inputsStackView.bottomAnchor, constant: 4),
            forgotPasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 28),
            buttonsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    override func configureViews() {
        view.backgroundColor = Color.backgroundLogo.uiColor
    }
}

// MARK: - LoginDisplaying
extension LoginViewController: LoginDisplaying {
    func displayViewState(_ state: LoginViewState) {
        switch state {
        case .loadingButton(let isLoading):
            primaryButton.setLoading(isLoading)
        case .loadingHud(let isLoading):
            if isLoading {
                showHudLoading()
            } else {
                hideHudLoading()
            }
        case .error(let message):
            showErrorAlert(message)
        }
    }
    
    func displayResendEmail(viewModel: AlertViewModel) {
        var viewModel = viewModel
        viewModel.firstButtonAction = { [weak self] _ in
            self?.interactor.resendEmailVerification()
        }
        showMessageAlert(viewModel: viewModel)
    }
    
    func displayResetPassword(viewModel: AlertViewModel) {
        var viewModel = viewModel
        viewModel.firstButtonAction = { [weak self] email in
            guard let self, let email else {
                return
            }
            self.interactor.resetPassword(email: email)
        }
        showMessageAlert(viewModel: viewModel)
    }
    
    func displayFeedbackAlert(title: String, message: String) {
        showMessageAlert(title: title, message: message)
    }
}

@objc private extension LoginViewController {
    func primaryButtonAction() {
        let isEmailValid = emailTextField.validate()
        let isPasswordValid = passwordTextField.validate()
        
        guard isEmailValid, isPasswordValid else {
            return
        }
        
        let loginModel = LoginUserRequestModel(email: emailTextField.text, password: passwordTextField.text)
        interactor.loginWith(userModel: loginModel)
    }
    
    func secondaryButtonAction() {
        interactor.signUpAction()
    }
    
    func forgotPasswordButtonAction() {
        interactor.didTapOnForgotPassword()
    }
}

extension LoginViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
