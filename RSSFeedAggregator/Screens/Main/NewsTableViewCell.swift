//
//  NewsTableViewCell.swift
//  RSSFeedAggregator
//
//  Created by dvoineu on 3.12.24.
//

import UIKit
import SnapKit
import SDWebImage

final class NewsTableViewCell: UITableViewCell {
    static let reuseId = "NewsTableViewCell"
    
    weak var viewModel: NewsTableViewCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            titleLabel.text = viewModel.title
            dateLabel.text = viewModel.date
            sourceTitleLabel.text = viewModel.sourceTitle
            titleLabel.alpha = viewModel.isReading ? 0.3 : 1.0
            dateLabel.alpha = viewModel.isReading ? 0.3 : 1.0
            sourceTitleLabel.alpha = viewModel.isReading ? 0.3 : 1.0
        }
    }

   private let cardView: UIView = {
        let view = UIView()
       view.backgroundColor = .systemBackground
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        label.textColor = .label

        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .gray

        return label
    }()
    
    let sourceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = .label

        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none
        
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Функции
    
    private func setupConstraints() {
        addSubview(cardView)
        
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cardView.addSubview(titleLabel)
        cardView.addSubview(dateLabel)
        cardView.addSubview(sourceTitleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottomMargin).offset(8)
            make.leading.equalTo(titleLabel)
            
        }
        
        sourceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp_bottomMargin).offset(8)
            make.leading.equalTo(titleLabel)
            make.bottom.equalTo(cardView).inset(8)
        }
    }
}
