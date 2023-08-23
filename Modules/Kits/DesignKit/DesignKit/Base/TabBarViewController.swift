import UIKit
import ProgressHUD

open class TabBarViewController<Interactor>: UITabBarController, ViewConfiguration {
    private lazy var loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.white.uiColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.fillWithSubview(subview: spinnerView)
        return view
    }()
    
    private lazy var spinnerView: SpinnerView = {
        let view = SpinnerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public let interactor: Interactor

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

    open func buildViewHierarchy() { }

    open func setupConstraints() { }

    open func configureViews() { }
}

public extension TabBarViewController where Interactor == Void {
    convenience init(_ interactor: Interactor = ()) {
        self.init(interactor: interactor)
    }
}

public extension TabBarViewController {
    func showLoading(_ style: UIActivityIndicatorView.Style = .medium) {
        DispatchQueue.main.async { [unowned self] in
            self.view.fillWithSubview(subview: loadingView)
            
            NSLayoutConstraint.activate([
                self.spinnerView.topAnchor.constraint(equalTo: self.loadingView.topAnchor),
                self.spinnerView.bottomAnchor.constraint(equalTo: self.loadingView.bottomAnchor),
                self.spinnerView.leadingAnchor.constraint(equalTo: self.loadingView.leadingAnchor),
                self.spinnerView.trailingAnchor.constraint(equalTo: self.loadingView.trailingAnchor)
            ])
            
            view.bringSubviewToFront(self.loadingView)
            self.spinnerView.showLoading(style: style)
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async { [unowned self] in
            self.loadingView.removeFromSuperview()
        }
    }
    
    func showHudLoading() {
        DispatchQueue.main.async {
            ProgressHUD.show()
        }
    }
    
    func hideHudLoading() {
        DispatchQueue.main.async {
            ProgressHUD.remove()
        }
    }
    
    func showMessageAlert(viewModel: AlertViewModel) {
        let alert = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: .alert)
        if let placeholder = viewModel.textFieldPlaceholder {
            alert.addTextField() { newTextField in
                newTextField.placeholder = placeholder
            }
        }
        let firstButton = UIAlertAction(title: viewModel.firstButtonTitle, style: .cancel, handler: {_ in
            viewModel.firstButtonAction?(alert.textFields?.first?.text)
        })
        let secondButton = UIAlertAction(title: viewModel.secondButtonTitle, style: .default, handler: { action in
            viewModel.secondButtonAction?(alert.textFields?.first?.text)
        })
        
        alert.addAction(firstButton)
        alert.addAction(secondButton)
        
        DispatchQueue.main.async { [unowned self] in
            self.present(alert, animated: true, completion: nil)
        }
    }
}
