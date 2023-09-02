import UIKit
import DesignKit

final class UserCell: UITableViewCell, ViewConfiguration {
    private lazy var avatar: ImageView = {
        let imageView = ImageView()
        imageView.layer.cornerRadius = 23
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var fullNameLabel: TextLabel = {
        let font = Font.md.make(isBold: true)
        let label = TextLabel(font: font)
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
    
    private lazy var textsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [fullNameLabel, statusLabel])
        stack.axis = .vertical
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buildViewHierarchy() {
        addSubview(avatar)
        addSubview(textsStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            avatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            avatar.heightAnchor.constraint(equalToConstant: 46),
            avatar.widthAnchor.constraint(equalToConstant: 46),
            avatar.topAnchor.constraint(equalTo: bottomAnchor, constant: 6),
            avatar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            avatar.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textsStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            textsStackView.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 16),
            textsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            textsStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    func configureViews() {
        accessoryType = .disclosureIndicator
    }
}

extension UserCell {
    func render(_ contact: UserContact) {
        fullNameLabel.text = contact.name
        statusLabel.text = contact.about
        
        if !contact.avatarLink.isEmpty {
            avatar.setAvatar(imageUrl: contact.avatarLink)
        } else {
            avatar.image = Image.avatarPlaceholder.image
        }
    }
}
