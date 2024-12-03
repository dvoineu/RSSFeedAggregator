//
//  RSSParser.swift
//  RSSFeedAggregator
//
//  Created by dvoineu on 2.12.24.
//

import Foundation
import CoreData

final class RSSParser: NSObject {

    private var feeds: [Feed] = []
    private var elementName: String = String()
    private var feedTitle = String()
    private var feedDate = String()
    private var feedDescription = String()
    
    private let networkDataFetcher = NetworkDataFetcher()
    
    func updateNews(currentSource: String, completion: @escaping ([Feed]) -> Void) {
        feeds = []
        CoreDataManager.shared.deleteNews()
        
        self.networkDataFetcher.fetchNewsData(sourceURL: currentSource) { [self] (data) in
            guard let data = data else { return }
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
            completion(feeds)
        }
    }
}

extension RSSParser: XMLParserDelegate {

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "item" {
            feedTitle = String()
            feedDate = String()
            feedDescription = String()
        }
        self.elementName = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        guard !data.isEmpty else { return }
        
        switch self.elementName {
        case "title":
            feedTitle += data
        case "pubDate":
            feedDate += data
        case "description":
            feedDescription += data
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            guard let savedNews = CoreDataManager.shared.addNews(feedTitle: feedTitle, feedDate: feedDate, feedDescription: feedDescription) else { return }
            feeds.append(savedNews)
        }
    }
}
