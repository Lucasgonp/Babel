import UIKit
import DesignKit

final class RequestsToJoinCell: UITableViewCell, ViewConfiguration {
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: TextLabel = {
        let font = Font.md.uiFont
        let label = TextLabel(font: font)
        label.textColor = Color.blueNative.uiColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let requestsCounterView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.blueNative.uiColor
        view.layer.cornerRadius = 11
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let requestsCountLabel: TextLabel = {
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
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(requestsCounterView)
        
        requestsCounterView.fillWithSubview(subview: requestsCountLabel, spacing: .init(top: 2, left: 4, bottom: 2, right: 4))
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            iconImageView.heightAnchor.constraint(equalToConstant: 25),
            iconImageView.widthAnchor.constraint(equalToConstant: 25),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: requestsCounterView.leadingAnchor, constant: -4),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            requestsCounterView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            requestsCounterView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            requestsCounterView.heightAnchor.constraint(greaterThanOrEqualToConstant: 22),
            requestsCounterView.widthAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    func configureViews() {
        accessoryType = .disclosureIndicator
    }
}

extension RequestsToJoinCell {
    func render(icon: UIImage, text: String, counter: Int) {
        iconImageView.image = icon
        titleLabel.text = text
        
        if counter == 0 {
            requestsCounterView.isHidden = true
        } else {
            requestsCounterView.isHidden = false
            requestsCountLabel.text = String(counter)
        }
    }
}
