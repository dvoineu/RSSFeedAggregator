//
//  NewsTableViewCellViewModelType.swift
//  RSSFeedAggregator
//
//  Created by dvoineu on 3.12.24.
//

import Foundation

protocol NewsTableViewCellViewModelType: AnyObject {
    var title: String { get }
    var date: String { get }
    var sourceTitle: String { get }
    var isReading: Bool  { get }
}

final class NewsTableViewCellViewModel: NewsTableViewCellViewModelType {
    
    private var feed: Feed
    
    var title: String {
        return feed.title ?? ""
    }
    
    var date: String {
        return feed.date?.formattedDate ?? "Ошибка форматирования даты"
    }
    
    var sourceTitle: String {
        return feed.title ?? ""
    }
    
    var isReading: Bool {
        return feed.isReading
    }
    
    init(feed: Feed) {
        self.feed = feed
    }
}
