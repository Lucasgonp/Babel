import UIKit
import DesignKit
import Lottie

protocol RequestsJoinGroupCellDelegate: AnyObject {
    func didTapApprove(id: String, completion: @escaping (_ didApprove: Bool) -> Void)
    func didTapDeny(id: String, completion: @escaping (_ didDeny: Bool) -> Void)
    func didFinishAnimation(id: String)
}

final class RequestsJoinGroupCell: UITableViewCell, ViewConfiguration {
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
    
    private lazy var descriptionLabel: TextLabel = {
        let font = Font.sm.uiFont
        let label = TextLabel(font: font)
        label.textColor = Color.grayscale400.uiColor
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var actionButtonsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [denyButton, approveButton])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var approveButton: UIView = {
        let image = UIImage(systemName: "checkmark.circle.fill")?.withRenderingMode(.alwaysOriginal)
        image?.withTintColor(Color.primary500.uiColor)
        let imageView = UIImageView(image: image)
        let view = UIView()
        view.fillWithSubview(subview: imageView)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnApprove)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var denyButton: UIView = {
        let image = UIImage(systemName: "xmark.circle.fill")?.withRenderingMode(.alwaysOriginal)
        image?.withTintColor(Color.warning300.uiColor.withAlphaComponent(0.8))
        let imageView = UIImageView(image: image)
        let view = UIView()
        view.fillWithSubview(subview: imageView)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnDeny)))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let approveAnimationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "ApproveAnimation")
        animationView.contentMode = .scaleToFill
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 0.7
        animationView.alpha = 0
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    private let denyAnimationView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "DenyAnimation")
        animationView.contentMode = .scaleToFill
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 0.7
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    private(set) var userId = String()
    
    weak var delegate: RequestsJoinGroupCellDelegate?
    
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
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(actionButtonsStack)
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
            fullNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            fullNameLabel.trailingAnchor.constraint(equalTo: actionButtonsStack.leadingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: actionButtonsStack.leadingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            actionButtonsStack.widthAnchor.constraint(equalToConstant: 96),
            actionButtonsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            actionButtonsStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            approveButton.heightAnchor.constraint(equalToConstant: 46),
            approveButton.widthAnchor.constraint(equalToConstant: 46)
        ])
        
        NSLayoutConstraint.activate([
            denyButton.heightAnchor.constraint(equalToConstant: 46),
            denyButton.widthAnchor.constraint(equalToConstant: 46)
        ])
    }
}

extension RequestsJoinGroupCell {
    func render(name: String, description: String, avatarLink: String, id: String) {
        fullNameLabel.text = name
        descriptionLabel.text = description
        userId = id
        
        avatarImageView.setImage(with: avatarLink) { [weak self] image in
            self?.avatarImageView.image = image ?? Image.avatarPlaceholder.image
        }
    }
}

@objc private extension RequestsJoinGroupCell {
    func didTapOnApprove() {
        delegate?.didTapApprove(id: userId, completion: { [weak self] didApprove in
            if didApprove {
                self?.setupApproveAnimation()
            }
        })
    }
    
    func didTapOnDeny() {
        delegate?.didTapDeny(id: userId, completion: { [weak self] didDeny in
            if didDeny {
                self?.setupDenyAnimation()
            }
        })
    }
}

private extension RequestsJoinGroupCell {
    func setupApproveAnimation() {
        contentView.addSubview(approveAnimationView)
        
        NSLayoutConstraint.activate([
            approveAnimationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            approveAnimationView.heightAnchor.constraint(equalToConstant: 62),
            approveAnimationView.widthAnchor.constraint(equalToConstant: 62),
            approveAnimationView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        UIView.animate(withDuration: 0.1) {
            self.actionButtonsStack.alpha = 0
            self.approveAnimationView.alpha = 1
            self.contentView.layoutIfNeeded()
            self.approveAnimationView.play { _ in
                self.delegate?.didFinishAnimation(id: self.userId)
            }
        }
    }
    
    func setupDenyAnimation() {
        contentView.addSubview(denyAnimationView)
        
        NSLayoutConstraint.activate([
            denyAnimationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            denyAnimationView.heightAnchor.constraint(equalToConstant: 62),
            denyAnimationView.widthAnchor.constraint(equalToConstant: 62),
            denyAnimationView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        UIView.animate(withDuration: 0.1) {
            self.actionButtonsStack.alpha = 0
            self.denyAnimationView.alpha = 1
            self.contentView.layoutIfNeeded()
            self.denyAnimationView.play { _ in
                self.delegate?.didFinishAnimation(id: self.userId)
            }
        }
    }
}
