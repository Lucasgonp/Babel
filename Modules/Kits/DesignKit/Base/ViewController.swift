import UIKit
import ProgressHUD

public protocol ViewConfiguration: AnyObject {
    func buildViewHierarchy()
    func setupConstraints()
    func configureViews()
    func configureStyles()
    func buildLayout()
}

public extension ViewConfiguration {
    func buildLayout() {
        buildViewHierarchy()
        setupConstraints()
        configureViews()
        configureStyles()
    }
    
    func setupConstraints() { }

    func configureViews() { }

    func configureStyles() { }
}

open class ViewController<Interactor, V: UIView>: UIViewController, ViewConfiguration {
    private lazy var spinnerView = SpinnerView()
    
    public let interactor: Interactor
    public var rootView = V()

    public init(interactor: Interactor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        buildLayout()
    }

    override open func loadView() {
        view = rootView
    }

    open func buildViewHierarchy() { }

    open func setupConstraints() { }

    open func configureViews() { }
}

public extension ViewController where Interactor == Void {
    convenience init(_ interactor: Interactor = ()) {
        self.init(interactor: interactor)
    }
}

extension ViewController: LoadingViewDelegate {
    public func dismissLoadingView() {
        spinnerView.removeFromSuperview()
    }
}

public extension ViewController {    
    func showLoading(backgroupColor: UIColor = Color.backgroundPrimary.uiColor, shouldBlur: Bool = false) {
        spinnerView = SpinnerView(backgroundColor: backgroupColor, shouldBlur: shouldBlur)
        spinnerView.delegate = self
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(spinnerView)
        
        NSLayoutConstraint.activate([
            spinnerView.topAnchor.constraint(equalTo: view.topAnchor),
            spinnerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            spinnerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            spinnerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func hideLoading() {
        spinnerView.removeFromSuperview()
    }
    
    func showHudLoading() {
        ProgressHUD.animate()
    }
    
    func hideHudLoading() {
        ProgressHUD.remove()
    }
    
    func showErrorAlert(_ errorMessage: String) {
        let title = Strings.Error.Generic.title.localized()
        let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.Error.Generic.button.localized(), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showMessageAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.Error.Generic.button.localized(), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showMessageAlert(title: String, message: String, button: String, completion: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: button, style: .cancel, handler: completion))
        present(alert, animated: true, completion: nil)
    }
    
    func showMessageAlert(viewModel: AlertViewModel) {
        let alert = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: .alert)
        if let placeholder = viewModel.textFieldPlaceholder {
            alert.addTextField() { newTextField in
                newTextField.placeholder = placeholder
            }
        }
        let firstButton = UIAlertAction(title: viewModel.firstButton.title, style: viewModel.firstButton.style, handler: {_ in
            viewModel.firstButtonAction?(alert.textFields?.first?.text)
        })
        let secondButton = UIAlertAction(title: viewModel.secondButton.title, style: viewModel.secondButton.style, handler: { action in
            viewModel.secondButtonAction?(alert.textFields?.first?.text)
        })
        
        alert.addAction(firstButton)
        alert.addAction(secondButton)
        present(alert, animated: true, completion: nil)
    }
}
