//
//  DetailNewsVC.swift
//  RSSFeedAggregator
//
//  Created by dvoineu on 2.12.24.
//

import UIKit
import CoreData
import SDWebImage

final class DetailNewsVC: UIViewController {
    
    // MARK: - Свойства
    private let detailView = DetailNewsView()
    var rssItem: Feed?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewComponents()
        configureRSSItem(rssItem: rssItem)
    }
    
    // MARK: - Функции
    private func configureViewComponents() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(detailView)
        
        let navBarHeight = getNavigationBarHeight()
        
        detailView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().inset(8)
            make.top.equalTo(navBarHeight + 8)
            make.bottom.equalToSuperview().inset(80)
        }
    }
    
    private func getNavigationBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        
        statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let navBarHeight = navigationController?.navigationBar.frame.height ?? 0
        return statusBarHeight + navBarHeight
    }
    
    private func configureRSSItem(rssItem: Feed?) {
        guard let title = rssItem?.title,
              let date = rssItem?.date,
              let description = rssItem?.feedDescription,
              let imageUrl = rssItem?.imageUrl else {
            return
        }
        
        detailView.feedImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "rss-placeholder"))
        
        detailView.titleLabel.text = title
        detailView.dateLabel.text = date.formattedDate
        detailView.detailTextView.text = removeHTMLTags(from: description)
    }
    
    private func removeHTMLTags(from str: String) -> String {
        let test = str
            .replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
            .replacingOccurrences(of: "&[^;]+;", with:
                                    "", options:.regularExpression, range: nil)
        return test
    }
}
