//
//  DetailNewsVC.swift
//  RSSFeedAggregator
//
//  Created by dvoineu on 2.12.24.
//

import UIKit
import CoreData

final class DetailNewsVC: UIViewController {
    
    // MARK: - Свойства
    private let detailView = DetailView()
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
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalTo(navBarHeight + 8)
            make.bottom.equalToSuperview().inset(80)
        }
    }
    
    private func getNavigationBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        
        if #available(iOS 13.0, *) {
            statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 40
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        
        let navBarHeight = navigationController?.navigationBar.frame.height ?? 0
        return statusBarHeight + navBarHeight
    }
    
    private func configureRSSItem(rssItem: Feed?) {
        guard let title = rssItem?.title,
              let date = rssItem?.date,
              let description = rssItem?.feedDescription else {
            return
        }
        
        detailView.titleLabel.text = title
        detailView.dateLabel.text = date.formattedDate
        print(detailView.detailTextView.text ?? "Nothing")
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
