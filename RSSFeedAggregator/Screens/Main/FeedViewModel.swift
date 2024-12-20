//
//  FeedViewModel.swift
//  RSSFeedAggregator
//
//  Created by dvoineu on 3.12.24.
//

import Foundation

protocol MainVCViewModelType {
    var news: [Feed] { get set }
    var currentSource: Source { get set }
    func numberOfRows() -> Int
    func cellViewModel(forIndexPath: IndexPath) -> NewsTableViewCellViewModelType?
}

final class FeedViewModel: MainVCViewModelType {

    var news: [Feed] = []
    var currentSource: Source = Source(title: "Ведомости", url: "https://www.vedomosti.ru/rss/articles")
    
    func numberOfRows() -> Int {
        return news.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> NewsTableViewCellViewModelType? {
        guard indexPath.row < news.count else { return nil }
        let feed = news[indexPath.row]
        return NewsTableViewCellViewModel(feed: feed, source: currentSource)
    }
    
}
