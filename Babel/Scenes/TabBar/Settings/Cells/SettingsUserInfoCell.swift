import UIKit
import DesignKit

final class SettingsUserInfoCell: UITableViewCell, ViewConfiguration {
    private lazy var avatar: ImageView = {
        let imageView = ImageView(image: Image.avatarPlaceholder.image)
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var fullNameLabel: TextLabel = {
        let font = Font.lg.make(isBold: true)
        let label = TextLabel(font: font)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var statusLabel: TextLabel = {
        let font = Font.sm.uiFont
        let label = TextLabel(font: font)
        label.textColor = Color.grayscale400.uiColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [fullNameLabel, statusLabel])
        stack.axis = .vertical
        stack.spacing = 4
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
        contentView.addSubview(avatar)
        contentView.addSubview(textsStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            avatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatar.heightAnchor.constraint(equalToConstant: 60),
            avatar.widthAnchor.constraint(equalToConstant: 60),
            avatar.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 16),
            avatar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            avatar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textsStackView.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 16),
            textsStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            textsStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configureViews() {
        accessoryType = .disclosureIndicator
    }
}

extension SettingsUserInfoCell {
    func render(_ dto: User) {
        fullNameLabel.text = dto.name
        statusLabel.text = dto.status
        
        avatar.image = nil
        avatar.setImage(with: dto.avatarLink) { [weak self] image in
            self?.avatar.image = image ?? Image.avatarPlaceholder.image
        }
    }
    
    func updateAvatar(image: UIImage) {
        avatar.image = image
    }
}
