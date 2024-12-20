//
//  UIAlertController+Extension.swift
//  RSSFeedAggregator
//
//  Created by dvoineu on 3.12.24.
//

import UIKit

extension UIAlertController {
    
    func isValidTitle(_ title: String) -> Bool {
        return title.count > 3 && title.rangeOfCharacter(from: .whitespacesAndNewlines) == nil
    }

    func isValidURL(_ url: String) -> Bool {
        return url.count > 0 && NSPredicate(format: "self matches %@", "http[s]?://(([^/:.[:space:]]+(.[^/:.[:space:]]+)*)|([0-9](.[0-9]{3})))(:[0-9]+)?((/[^?#[:space:]]+)([^#[:space:]]+)?(#.+)?)?").evaluate(with: url)
    }

    @objc func textDidChangeInLoginAlert() {
        if let title = textFields?[0].text,
            let url = textFields?[1].text,
            let action = actions.last {
            action.isEnabled = isValidURL(url) && isValidTitle(title)
        }
    }
}
