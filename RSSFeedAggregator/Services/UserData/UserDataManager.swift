//
//  UserDataManager.swift
//  RSSFeedAggregator
//
//  Created by dvoineu on 3.12.24.
//

import Foundation

struct UserDataManager {
    static let (sourceTitleKey, sourceURLKey) = ("sourceTitle", "sourceURL")
    static let userSessionKey = "RSSFeeds"
    private static let userDefault = UserDefaults.standard

    struct UserDetails {
        let savedSourcesTitle: [String]
        let savedSourcesURL: [String]

        init(_ json: [String: [String]]) {
                        
            self.savedSourcesTitle = json[sourceTitleKey] ?? ["Banki", "Vedomosti"]
            
            self.savedSourcesURL = json[sourceURLKey] ?? ["https://www.banki.ru/xml/news.rss", "https://www.vedomosti.ru/rss/articles"]
        }
    }
    static func saveSources(sourcesTitle: [String], sourcesURL: [String]) {
        userDefault.set([sourceTitleKey: sourcesTitle, sourceURLKey: sourcesURL], forKey: userSessionKey)
    }
    
    static func getSourcesTitle() -> [String] {
        
        let value = UserDetails((userDefault.value(forKey: userSessionKey) as? [String: [String]]) ?? [:])
        
        return value.savedSourcesTitle
    }

    static func getSourcesURL() -> [String] {
        let value = UserDetails((userDefault.value(forKey: userSessionKey) as? [String: [String]]) ?? [:])
        return value.savedSourcesURL
    }

    static func clearUserData() {
        userDefault.removeObject(forKey: userSessionKey)
    }
}
