import UIKit
import DesignKit

final class RecentChatCell: UITableViewCell, ViewConfiguration {
    private lazy var avatarImageView: ImageView = {
        let imageView = ImageView()
        imageView.layer.cornerRadius = 28
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
    
    private lazy var lastMassageLabel: TextLabel = {
        let font = Font.sm.uiFont
        let label = TextLabel(font: font)
        label.textColor = Color.grayscale400.uiColor
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var timeLabel: TextLabel = {
        let font = Font.sm.uiFont
        let label = TextLabel(font: font)
        label.textColor = Color.grayscale400.uiColor
        label.textAlignment = .right
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var unreadCountView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.primary500.uiColor
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private lazy var unreadCountLabel: TextLabel = {
        let font = Font.sm.uiFont
        let label = TextLabel(font: font)
        label.textColor = Color.backgroundPrimary.uiColor
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        contentView.addSubview(avatarImageView)
        contentView.addSubview(fullNameLabel)
        contentView.addSubview(lastMassageLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(unreadCountView)
        
        unreadCountView.fillWithSubview(subview: unreadCountLabel, spacing: .init(top: 2, left: 4, bottom: 2, right: 4))
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            avatarImageView.heightAnchor.constraint(equalToConstant: 56),
            avatarImageView.widthAnchor.constraint(equalToConstant: 56),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            fullNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            fullNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            lastMassageLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 4),
            lastMassageLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            lastMassageLabel.trailingAnchor.constraint(equalTo: unreadCountView.leadingAnchor, constant: -8),
            lastMassageLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            timeLabel.leadingAnchor.constraint(equalTo: fullNameLabel.trailingAnchor, constant: 4),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            unreadCountView.heightAnchor.constraint(greaterThanOrEqualToConstant: 22),
            unreadCountView.widthAnchor.constraint(equalToConstant: 22),
            unreadCountView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            unreadCountView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}

extension RecentChatCell {
    func render(dto: RecentChatModel) {
        fullNameLabel.text = dto.groupName ?? dto.receiverName
        lastMassageLabel.text = dto.type == .group ? "\(dto.receiverName): \(dto.lastMassage)" : dto.lastMassage
        timeLabel.text = (dto.date ?? Date()).lastMessageDate()
        unreadCountLabel.text = String(dto.unreadCounter)
        
        if dto.unreadCounter != 0 {
            unreadCountView.isHidden = false
        } else {
            unreadCountView.isHidden = true
        }
        
        avatarImageView.setImage(with: dto.avatarLink, placeholderImage: Image.avatarPlaceholder.image)
    }
}
