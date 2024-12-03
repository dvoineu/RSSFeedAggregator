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

class FeedViewModel: MainVCViewModelType {

    var news: [Feed] = []
    var currentSource: Source = Source(title: "Ведомости", url: "https://www.vedomosti.ru/rss/news")
    
    func numberOfRows() -> Int {
        return news.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> NewsTableViewCellViewModelType? {
        let feed = news[indexPath.row]
        return NewsTableViewCellViewModel(feed: feed)
    }
    
}
