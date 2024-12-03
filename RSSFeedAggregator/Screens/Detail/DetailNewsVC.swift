//
//  DetailNewsVC.swift
//  RSSFeedAggregator
//
//  Created by dvoineu on 2.12.24.
//

import UIKit
import CoreData

final class DetailNewsVC: UIViewController {
    
    private let detailView = DetailView()
    var rssItem: Feed? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewComponents()
        
        configureRSSItem(rssItem: rssItem)
    }
    
    private func configureViewComponents() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(detailView)
        let navBarHeight = UIApplication.shared.statusBarFrame.size.height +
                 (navigationController?.navigationBar.frame.height ?? 0.0)
        
        
        detailView.setPosition(top: view.topAnchor,
                               left: view.leftAnchor,
                               bottom: view.bottomAnchor,
                               right: view.rightAnchor,
                               paddingTop: navBarHeight + 8,
                               paddingLeft: 8,
                               paddingBottom: 0,
                               paddingRight: 8)
    }
    
    private func configureRSSItem(rssItem: Feed?) {
        guard let title = rssItem?.title,
              let date = rssItem?.date,
              let description = rssItem?.feedDescription else {
            return
        }
        
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
