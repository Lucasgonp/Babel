import UIKit
import DesignKit

final class OpenAICell: UITableViewCell, ViewConfiguration {
    private lazy var avatar: ImageView = {
        let imageView = ImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 23
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var fullNameLabel: TextLabel = {
        let font = Font.md.make(isBold: true)
        let label = TextLabel(font: font)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var statusLabel: TextLabel = {
        let font = Font.sm.uiFont
        let label = TextLabel(font: font)
        label.textColor = Color.grayscale400.uiColor
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var adminLabel: TextLabel = {
        let font = Font.sm.uiFont
        let label = TextLabel(font: font)
        label.textColor = Color.grayscale400.uiColor
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [fullNameLabel, statusLabel])
        stack.axis = .vertical
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var allStackViews: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [textsStackView])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private(set) var completionHandler: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildViewHierarchy() {
        contentView.addSubview(avatar)
        contentView.addSubview(allStackViews)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            avatar.heightAnchor.constraint(equalToConstant: 46),
            avatar.widthAnchor.constraint(equalToConstant: 46),
            avatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            avatar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            avatar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            allStackViews.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            allStackViews.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 16),
            allStackViews.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}

extension OpenAICell {
    func render(_ dto: OpenAIDTO) {
        fullNameLabel.text = dto.name
        statusLabel.text = dto.bio
        avatar.image = dto.avatar
        completionHandler = dto.action
        
        if dto.avatar.renderingMode == .alwaysTemplate {
            avatar.tintColor = Color.grayscale400.uiColor
        }
    }
}
