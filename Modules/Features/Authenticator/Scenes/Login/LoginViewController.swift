import UIKit
import DesignKit
import StorageKit

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
    enum Texts {
        static let emailPlaceholder = Strings.Login.Field.Email.placeholder.localized()
        static let passwordPlaceholder = Strings.Login.Field.Password.placeholder.localized()
        static let forgotPassword = Strings.Login.Button.forgotPassword.localized()
        static let register = Strings.Login.Button.register.localized()
        static let login = Strings.Login.Button.login.localized()
    }
}

final class LoginViewController: ViewController<LoginInteractorProtocol, UIView> {
    fileprivate enum Layout { }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .onDrag
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
        textField.render(.standard(placeholder: Layout.Texts.emailPlaceholder, keyboardType: .emailAddress))
        textField.validations = [EmailValidation()]
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordTextField: TextField = {
        let textField = TextField()
        textField.render(.standard(placeholder: Layout.Texts.passwordPlaceholder, isSecureTextEntry: true))
        textField.validations = [PasswordValidation()]
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var forgotPasswordButton: Button = {
        let button = Button()
        button.render(.tertiary(title: Layout.Texts.forgotPassword))
        button.addTarget(self, action: #selector(forgotPasswordButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var primaryButton: Button = {
        let button = Button()
        button.render(.primary(title: Layout.Texts.login))
        button.addTarget(self, action: #selector(primaryButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var secondaryButton: Button = {
        let button = Button()
        button.render(.secondary(title: Layout.Texts.register))
        button.addTarget(self, action: #selector(secondaryButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var alertView: TermsAlertView = {
        let alertView = TermsAlertView()
        alertView.delegate = self
        alertView.translatesAutoresizingMaskIntoConstraints = false
        return alertView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureKeyboardObservers()
        
        if StorageLocal.shared.getBool(key: kTERMSAGREED) != true {
            alertView.showAlert(from: self)
            view.subviews.forEach({ 
                if !($0 is TermsAlertView) {
                    $0.isUserInteractionEnabled = false
                }
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideKeyboard()
    }
    
    override func buildViewHierarchy() {
        view.fillWithSubview(subview: scrollView)
        scrollView.fillWithSubview(subview: containerView)
        containerView.addSubview(brandImageView)
        containerView.addSubview(inputsStackView)
        containerView.addSubview(forgotPasswordButton)
        containerView.addSubview(buttonsStackView)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            brandImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 46),
            brandImageView.heightAnchor.constraint(equalToConstant: 120),
            brandImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            brandImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            inputsStackView.topAnchor.constraint(equalTo: brandImageView.bottomAnchor, constant: 22),
            inputsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            inputsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            forgotPasswordButton.topAnchor.constraint(equalTo: inputsStackView.bottomAnchor, constant: 4),
            forgotPasswordButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 28),
            buttonsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            buttonsStackView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor)
        ])
    }
    
    override func configureViews() {
        view.backgroundColor = Color.backgroundPrimary.uiColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
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

extension LoginViewController: TermsAlertViewDelegate {
    func didTapPrimaryButton() {
        let terms = TermsViewController()
        navigationController?.pushViewController(terms, animated: true)
    }
    
    func didTapSecondaryButton() {
        StorageLocal.shared.saveBool(true, key: kTERMSAGREED)
        alertView.hideAlert()
        view.subviews.forEach({ $0.isUserInteractionEnabled = true })
    }
}

@objc private extension LoginViewController {
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == .zero {
                UIView.animate(withDuration: 0.5) { [weak self] in
                    self?.view.frame.origin.y -= (keyboardSize.height/9)
                }
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != .zero {
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.view.frame.origin.y = .zero
            }
        }
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    func primaryButtonAction() {
        let isEmailValid = emailTextField.validate()
        let isPasswordValid = passwordTextField.validate()
        
        hideKeyboard()
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

private extension LoginViewController {
    func configureKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
