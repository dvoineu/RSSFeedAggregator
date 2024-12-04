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
            
            if let imageURLString = viewModel.imageUrl, let imageURL = URL(string: imageURLString) {
                feedImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "rss-placeholder"))
            } else {
                feedImage.image = UIImage(named: "rss-placeholder")
            }
            
            feedImage.alpha = viewModel.isReading ? 0.3 : 1.0
            titleLabel.alpha = viewModel.isReading ? 0.3 : 1.0
            dateLabel.alpha = viewModel.isReading ? 0.3 : 1.0
            sourceTitleLabel.alpha = viewModel.isReading ? 0.3 : 1.0
        }
    }
    
    let feedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10.0
        
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        label.textColor = .label

        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        label.textColor = .gray

        return label
    }()
    
    let sourceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = .label

        return label
    }()
    
    private lazy var vStackView: UIStackView = {
        let stackView  = UIStackView(arrangedSubviews: [titleLabel, dateLabel, sourceTitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Функции
    
    private func setupConstraints() {
        
        contentView.addSubview(feedImage)
        contentView.addSubview(vStackView)
        
        feedImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.top.bottom.equalToSuperview().inset(8)
            make.size.equalTo(80)
        }
        
        vStackView.snp.makeConstraints { make in
            make.leading.equalTo(feedImage.snp_trailingMargin).offset(16)
            make.top.bottom.trailing.equalToSuperview().inset(8)
        }
    }
}
