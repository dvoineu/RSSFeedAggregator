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
    private var elementName = ""
    private var feedTitle = ""
    private var feedDate = ""
    private var feedImageURL = ""
    private var feedDescription = ""
    private var currentSource = ""
    
    private let networkDataFetcher = NetworkDataFetcher()
    
    func parse(data: Data, source: String) -> [Feed]? {
        currentSource = source
        let parser = XMLParser(data: data)
        parser.delegate = self
        return parser.parse() ? feeds : nil
    }
    
    func updateNews(currentSource: String, completion: @escaping ([Feed]) -> Void) {
        feeds = []
        CoreDataManager.shared.deleteNews()
        
        networkDataFetcher.fetchNewsData(sourceURL: currentSource) { [self] (data) in
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
        
        self.elementName = elementName
        if elementName == "item" {
            feedTitle = ""
            feedDate = ""
            feedDescription = ""
            feedImageURL = ""
        }
        
        if elementName == "enclosure", let url = attributeDict["url"] {
            feedImageURL = url
        }
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
            guard let savedNews = CoreDataManager.shared.addNews(feedTitle: feedTitle, feedDate: feedDate, feedDescription: feedDescription, imageUrl: feedImageURL) else { return }
            feeds.append(savedNews)
        }
    }
}
