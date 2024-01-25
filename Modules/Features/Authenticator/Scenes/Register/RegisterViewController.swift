import UIKit
import DesignKit

enum RegisterViewState {
    case success
    case loading(isLoading: Bool)
    case error(message: String)
}

protocol RegisterDisplaying: AnyObject {
    func displayViewState(_ state: RegisterViewState)
}

private extension RegisterViewController.Layout {
    enum Texts {
        static let emailPlaceholder = Strings.Register.Field.Email.placeholder.localized()
        static let fullNamePlaceholder = Strings.Register.Field.FullName.placeholder.localized()
        static let usernamePlaceholder = Strings.Register.Field.Username.placeholder.localized()
        static let passwordPlaceholder = Strings.Register.Field.Password.placeholder.localized()
        static let register = Strings.Register.Button.register.localized()
        static let login = Strings.Register.Button.login.localized()
    }
}

final class RegisterViewController: ViewController<RegisterInteractorProtocol, UIView> {
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
        let stack = UIStackView(arrangedSubviews: [emailTextField, fullNameTextField, usernameTextField, passwordTextField, primaryButton, secondaryButton])
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
    
    private lazy var fullNameTextField: TextField = {
        let textField = TextField()
        textField.render(.standard(placeholder: Layout.Texts.fullNamePlaceholder, autocapitalizationType: .words))
        textField.validations = [FullNameValidation()]
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var usernameTextField: TextField = {
        let textField = TextField()
        textField.render(.standard(placeholder: Layout.Texts.usernamePlaceholder, textLength: 32))
        textField.validations = [UsernameValidation()]
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
    
    private lazy var primaryButton: Button = {
        let button = Button()
        button.render(.primary(title: Layout.Texts.register))
        button.addTarget(self, action: #selector(primaryButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var secondaryButton: Button = {
        let button = Button()
        button.render(.secondary(title: Layout.Texts.login))
        button.addTarget(self, action: #selector(secondaryButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureKeyboardObservers()
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
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            brandImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 42),
            brandImageView.heightAnchor.constraint(equalToConstant: 120),
            brandImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            brandImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            inputsStackView.topAnchor.constraint(equalTo: brandImageView.bottomAnchor, constant: 22),
            inputsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            inputsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
    }

    override func configureViews() {
        view.backgroundColor = Color.backgroundPrimary.uiColor
        inputsStackView.setCustomSpacing(32, after: passwordTextField)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }
}

// MARK: - RegisterDisplaying
extension RegisterViewController: RegisterDisplaying {
    func displayViewState(_ state: RegisterViewState) {
        switch state {
        case .success:
            interactor.emailSentToNewUser()
        case .loading(let isLoading):
            primaryButton.setLoading(isLoading)
        case .error(let message):
            showErrorAlert(message)
        }
    }
}

@objc private extension RegisterViewController {
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == .zero {
                UIView.animate(withDuration: 0.5) { [weak self] in
                    self?.view.frame.origin.y -= (keyboardSize.height/6)
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
        let isFullNameValid = fullNameTextField.validate()
        let isUsernameValid = usernameTextField.validate()
        let isEmailValid = emailTextField.validate()
        let isPasswordValid = passwordTextField.validate()
        
        hideKeyboard()
        guard isFullNameValid,
              isUsernameValid,
              isEmailValid,
              isPasswordValid else {
            return
        }
        
        let registerModel = RegisterUserRequestModel(
            fullName: fullNameTextField.text,
            email: emailTextField.text,
            username: usernameTextField.text,
            password: passwordTextField.text
        )
        interactor.registerUser(registerModel)
    }
    
    func secondaryButtonAction() {
        interactor.backToLoginView()
    }
}

private extension RegisterViewController {
    func configureKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
