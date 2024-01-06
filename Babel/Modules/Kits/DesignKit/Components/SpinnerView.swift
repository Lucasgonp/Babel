import UIKit

public protocol LoadingViewDelegate: AnyObject {
    func dismissLoadingView()
}

public final class SpinnerView: UIView {
    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        spinner.color = spinnerColor
        spinner.backgroundColor = spinnerBackgroundColor
        return spinner
    }()
    
    private var spinnerColor: UIColor = .gray
    private var spinnerBackgroundColor: UIColor = Color.clear.uiColor
    private var backgroundViewColor: UIColor = Color.backgroundPrimary.uiColor
    private var blurStyle: UIBlurEffect.Style = UserInterface.style == .dark ? .dark : .light
    private var shouldBlur: Bool = false
    
    public weak var delegate: LoadingViewDelegate?
    
    public init(
        backgroundColor: UIColor = Color.backgroundPrimary.uiColor,
        spinnerColor: UIColor = .gray,
        spinnerBackgroundColor: UIColor = .clear,
        shouldBlur: Bool = false
    ) {
        super.init(frame: .zero)
        self.backgroundViewColor = backgroundColor
        self.spinnerBackgroundColor = spinnerBackgroundColor
        self.spinnerColor = spinnerColor
        self.shouldBlur = shouldBlur
        buildLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SpinnerView: ViewConfiguration {
    public func buildViewHierarchy() {
        addSubview(spinner)
    }
    
    public func setupConstraints() {
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.heightAnchor.constraint(equalToConstant: 80),
            spinner.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    public func configureViews() {
        backgroundColor = backgroundViewColor
        
        if shouldBlur {
            let blurView = UIView()
            fillWithSubview(subview: blurView)
            sendSubviewToBack(blurView)
            bringSubviewToFront(spinner)
            
            blurView.applyBlurEffect(alpha: 0.6, style: blurStyle)
        }
    }
}

extension SpinnerView {
    func showLoading(style: UIActivityIndicatorView.Style) {
        spinner.style = style
        spinner.isHidden = false
        reloadInputViews()
        
        spinner.startAnimating()
    }
    
    func hideLoading() {
        spinner.stopAnimating()
    }
}
