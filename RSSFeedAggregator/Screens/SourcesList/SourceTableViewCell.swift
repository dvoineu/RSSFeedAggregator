//
//  SourceTableViewCell.swift
//  RSSFeedAggregator
//
//  Created by dvoineu on 3.12.24.
//

import UIKit

final class SourceTableViewCell: UITableViewCell {
    static let reuseId = "SoruceTableViewCell"
    
    weak var viewModel: SourceTableViewCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            titleLabel.text = viewModel.title
            urlLabel.text = viewModel.url
            self.accessoryType = viewModel.isCurrent ? .checkmark : .none
        }
    }

    // MARK: - Создание объектов кастомной ячейки

   private let cardView: UIView = {
        let view = UIView()
       view.backgroundColor = .systemBackground
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        label.textColor = .label

        return label
    }()

    let urlLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .gray

        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none
        
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        
        self.tintColor = .link
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        addSubview(cardView)
        
        cardView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(12)
        }
        
        let bottomConstraint = cardView.bottomAnchor.constraint(equalTo: bottomAnchor)
        bottomConstraint.priority = UILayoutPriority(999)
        bottomConstraint.isActive = true
        
        cardView.addSubview(titleLabel)
        cardView.addSubview(urlLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        urlLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
