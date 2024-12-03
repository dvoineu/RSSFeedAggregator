//
//  SourceTableViewCellViewModelType.swift
//  RSSFeedAggregator
//
//  Created by dvoineu on 3.12.24.
//

protocol SourceTableViewCellViewModelType: AnyObject {
    var title: String { get }
    var url: String { get }
    var isCurrent: Bool  { get }
}

final class SourceTableViewCellViewModel: SourceTableViewCellViewModelType {
    private var source: Source
    
    var title: String {
        return source.title
    }
    
    var url: String {
        return source.url
    }
    
    var isCurrent: Bool {
        return source.isCurrent
    }
    
    init (source: Source) {
        self.source = source
    }
}

