import UIKit

public class Button: UIButton {
    private struct ButtonState {
        var state: UIControl.State
        var title: NSAttributedString?
        var backgroundColor: UIColor?
    }

    private lazy var buttonState: ButtonState = .init(state: .normal)
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = Color.grayscale500.uiColor
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    // Life cycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Public methods
    public func render(_ theme: ButtonTheme) {
        let dto = theme.dto
        makeAttributes(text: dto.title)
        setTitleColor(dto.titleColor.uiColor, for: .normal)
        backgroundColor = dto.backgroundColor.uiColor
        layer.cornerRadius = dto.cornerRadius
        
        if let minimumHeight = dto.minimumHeight {
            setMinimumHeight(minimumHeight)
        }
    }

    public func showLoading() {
        activityIndicator.startAnimating()
        buttonState = .init(
            state: .disabled,
            title: currentAttributedTitle,
            backgroundColor: backgroundColor
        )
        
        backgroundColor = Color.clear.uiColor
        setAttributedTitle(nil, for: .normal)
        isEnabled = false
    }

    public func hideLoading() {
        activityIndicator.stopAnimating()
        
        backgroundColor = buttonState.backgroundColor
        setAttributedTitle(buttonState.title, for: .normal)
        isEnabled = true
    }
    
    public func setLoading(_ isLoading: Bool) {
        if isLoading {
            showLoading()
        } else {
            hideLoading()
        }
    }
}

extension Button: ViewConfiguration {
    public func buildViewHierarchy() {
        addSubview(activityIndicator)
    }
    
    public func setupConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

private extension Button {
    func makeAttributes(text: String, for state: UIControl.State = .normal) {
        let boldText = text.slice(from: "**", to: "**") ?? String()
        let clearText = text.replacingOccurrences(of: boldText, with: String()).replacingOccurrences(of: "*", with: String())
        
        let attributedTitle = NSMutableAttributedString(
            string: clearText,
            attributes: [.font: Font.md.uiFont]
        )
        attributedTitle.append(NSAttributedString(
            string: boldText,
            attributes: [.font: Font.md.make(isBold: true)]
        ))
        
        
        setAttributedTitle(attributedTitle, for: state)
    }
    
    func setMinimumHeight(_ height: CGFloat) {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(greaterThanOrEqualToConstant: height)
        ])
    }
}
