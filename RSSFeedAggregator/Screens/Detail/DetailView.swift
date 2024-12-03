//
//  DetailView.swift
//  RSSFeedAggregator
//
//  Created by dvoineu on 3.12.24.
//

import UIKit
import SnapKit

final class DetailView: UIView {
    
   private let cardView: UIView = {
        let view = UIView()
       view.backgroundColor = .systemBackground
        return view
    }()
    
    private let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
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
        addSubview(lineView)
        
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(3)
            make.top.leading.trailing.equalTo(cardView)
        }
        
        cardView.addSubview(dateLabel)
        cardView.addSubview(titleLabel)
        cardView.addSubview(detailTextView)
        
        dateLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(cardView).inset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.leading.equalTo(dateLabel)
            make.trailing.equalTo(cardView).inset(8)
        }
        
        detailTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
            make.trailing.bottom.equalTo(cardView).inset(8)
        }
    }
}
