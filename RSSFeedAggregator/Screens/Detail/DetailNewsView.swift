//
//  DetailView.swift
//  RSSFeedAggregator
//
//  Created by dvoineu on 3.12.24.
//

import UIKit
import SnapKit

final class DetailNewsView: UIView {
    
   private let cardView: UIView = {
        let view = UIView()
       view.backgroundColor = .systemBackground
        return view
    }()
    
    let feedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10.0
        
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        label.textColor = .label

        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .gray

        return label
    }()
    
    var detailTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        textView.textColor = .label
        textView.isEditable = false
        textView.isSelectable = false
        textView.showsVerticalScrollIndicator = false
        return textView
    }()
    
    private lazy var vStackView: UIStackView = {
        let stackView  = UIStackView(arrangedSubviews: [feedImage, dateLabel, titleLabel, detailTextView])
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    // MARK: - Инициализация

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewComponents()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

    }
    
    private func configureViewComponents() {
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
    }
    
    private func setupConstraints() {
        addSubview(cardView)
        
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cardView.addSubview(vStackView)
        
        feedImage.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(8)
            make.height.equalTo(200)
        }
        
        vStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
