import UIKit

public class Button: UIButton {
    private struct ButtonState {
        var state: UIControl.State
        var title: String?
    }

    private lazy var buttonStates: [ButtonState] = []
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = Color.black.uiColor
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
        
        setupMinimumHeight()
    }

    public func showLoading() {
        activityIndicator.startAnimating()
        var buttonStates: [ButtonState] = []
        for state in [UIControl.State.disabled] {
            let buttonState = ButtonState(state: state, title: title(for: state))
            buttonStates.append(buttonState)
            setAttributedTitle(nil, for: .normal)
            setImage(UIImage(), for: state)
        }
        self.buttonStates = buttonStates
        isEnabled = false
    }

    public func hideLoading() {
        activityIndicator.stopAnimating()
        for buttonState in buttonStates {
            makeAttributes(text: buttonState.title ?? String(), for: buttonState.state)
        }
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
    
    func setupMinimumHeight() {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(greaterThanOrEqualToConstant: 42)
        ])
    }
}
