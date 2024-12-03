//
//  URL+Extension.swift
//  RSSAggregator
//
//  Created by dvoineu on 2.12.24.
//

import Foundation

extension URL {
    var normalized: URL {
        guard scheme == nil else { return self }
        
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        components.scheme = "https"
        
        return components.url ?? self
    }
}
