//
//  Assets.swift
//  RSS Feed
//
//  Created by Vedran Hernaus on 18.04.2024..
//

import UIKit

enum Assets: String {
    case plus
    case chevronRight = "chevron.right"
    case rssPlaceholder = "rss-placeholder"
    case settings = "gearshape.fill"
    case home = "house.fill"
    case rssList = "list.bullet"
    
    var image: UIImage? {
        UIImage(named: rawValue)
    }
    
    var systemImage: UIImage? {
        UIImage(systemName: rawValue)
    }
}
