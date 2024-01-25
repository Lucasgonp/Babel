import UIKit

public class TextField: UIView {
    public var validations = [Validation]()
    
    public lazy var text: String = {
        return textFieldInput.text ?? String()
    }() {
        didSet {
            textFieldInput.text = text
            updateTextLength()
        }
    }
    
    private var _state: State = .none {
        didSet {
            setupFeedbackView()
        }
    }
    
    public lazy var returnKeyType: UIReturnKeyType = {
        return textFieldInput.returnKeyType
    }() {
        didSet {
            textFieldInput.returnKeyType = returnKeyType
        }
    }
    
    public lazy var enablesReturnKeyAutomatically: Bool = {
        return textFieldInput.enablesReturnKeyAutomatically
    }() {
        didSet {
            textFieldInput.enablesReturnKeyAutomatically = enablesReturnKeyAutomatically
        }
    }
    
    public weak var delegate: TextFieldDelegate?
    
    private lazy var hintView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var hintLabel: TextLabel = {
        let label = TextLabel()
        label.font = Font.sm.uiFont
        label.textColor = Color.grayscale600.uiColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = false
        return label
    }()
    
    private lazy var textFieldInput: TextFieldInput = {
        let textField = TextFieldInput()
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        textField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.grayscale400.uiColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [inputsStackView, lineView, feedbackView])
        stack.axis = .vertical
        stack.spacing = .zero
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var componentsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [infoStackView, textLengthLabel])
        stack.axis = .horizontal
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var inputsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [hintView, textFieldInput])
        stack.axis = .vertical
        stack.spacing = .zero
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var feedbackStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [feedbackIcon, feedbackText])
        stack.axis = .horizontal
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var feedbackIcon: ImageView = {
        let icon = Icon.feedbackDanger.image
        let imageView = ImageView(icon: icon)
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var feedbackText: TextLabel = {
        let text = TextLabel()
        text.font = Font.xs.uiFont
        text.textColor = Color.warning500.uiColor
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private lazy var feedbackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var textLengthLabel: TextLabel = {
        let text = TextLabel()
        text.font = Font.sm.uiFont
        text.textColor = Color.grayscale300.uiColor
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textAlignment = .right
        text.isHidden = true
        return text
    }()
    
    private var isHintAlwaysVisible = false {
        didSet {
            hintLabel.isHidden = !isHintAlwaysVisible
        }
    }
    
    private var textLength: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLayout()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func render(_ theme: TextFieldTheme) {
        textFieldInput.render(theme)
        
        let dto = theme.dto
        hintLabel.text = dto.hint ??  dto.placeholder
        lineView.isHidden = !dto.hasDividorView
        hintView.isHidden = dto.hint == nil
        feedbackView.isHidden = !dto.hasFeedback
        isHintAlwaysVisible = dto.isHintAlwaysVisible
        
        if let textLength = dto.textLength {
            self.textLengthLabel.isHidden = false
            self.textLength = textLength
        }
        
        if let border = theme.border {
            inputsStackView.layer.cornerRadius = border.cornerRadius
            inputsStackView.layer.borderWidth = border.borderWidth
            inputsStackView.layer.borderColor = border.borderColor.uiColor.cgColor
            inputsStackView.clipsToBounds = true
        }
    }
    
    public func validate() -> Bool {
        let message = validations
            .compactMap { $0.run(textFieldInput.text ?? "") }
            .compactMap { $0.message }
            .joined(separator: ", ")
        
        if !message.isEmpty {
            _state = .error(message)
            return false
        } else {
            self._state = .success
            return true
        }
    }
    
    func setupFeedbackView() {
        switch _state {
        case .none, .success:
            feedbackIcon.isHidden = true
            feedbackText.isHidden = true
            lineView.backgroundColor = Color.grayscale400.uiColor
        case .error(let message):
            feedbackIcon.isHidden = false
            feedbackText.isHidden = false
            lineView.backgroundColor = Color.warning500.uiColor
            feedbackText.text = message
        }
    }
}

extension TextField: ViewConfiguration {
    public func buildViewHierarchy() {
        addSubview(componentsStackView)
        hintView.addSubview(hintLabel)
        feedbackView.addSubview(feedbackStackView)
    }
    
    public func setupConstraints() {
        NSLayoutConstraint.activate([
            componentsStackView.topAnchor.constraint(equalTo: topAnchor),
            componentsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            componentsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            componentsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            hintLabel.topAnchor.constraint(equalTo: hintView.topAnchor),
            hintLabel.leadingAnchor.constraint(equalTo: hintView.leadingAnchor, constant: 6),
            hintLabel.trailingAnchor.constraint(equalTo: hintView.trailingAnchor, constant: -6),
            hintLabel.bottomAnchor.constraint(equalTo: hintView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textLengthLabel.widthAnchor.constraint(equalToConstant: 18)
        ])
        
        NSLayoutConstraint.activate([
            hintView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        NSLayoutConstraint.activate([
            feedbackView.heightAnchor.constraint(equalToConstant: 12)
        ])
        
        NSLayoutConstraint.activate([
            textFieldInput.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        NSLayoutConstraint.activate([
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}

@objc private extension TextField {
    func textFieldDidChange() {
        _state = .none
        text = textFieldInput.text ?? String()
        
        if let text = textFieldInput.text, !text.isEmpty {
            hintLabel.isHidden = false
        } else if !isHintAlwaysVisible {
            hintLabel.isHidden = true
        }
        
        if let textLength {
            updateTextLength()
            
            if text.count >= textLength {
                textFieldInput.text?.removeLast()
                text = textFieldInput.text ?? String()
            }
        }
        
        delegate?.textFieldDidChange(textFieldInput)
    }
    
    func textFieldDidBeginEditing() {
        delegate?.textFieldDidBeginEditing(textFieldInput)
    }
    
    func textFieldDidEndEditing() {
        delegate?.textFieldDidEndEditing(textFieldInput)
    }
}


extension TextField: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.textFieldShouldReturn(textFieldInput)
        return validate()
    }
}

private extension TextField {
    func updateTextLength() {
        if let textLength {
            self.textLengthLabel.text = "\(textLength - (text.count + 1))"
        }
    }
}
