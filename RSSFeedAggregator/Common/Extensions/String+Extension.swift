//
//  String+Extension.swift
//  RSSAggregator
//
//  Created by dvoineu on 2.12.24.
//

import Foundation

extension String {
    func localized(_ args: CVarArg...) -> String {
        guard !isEmpty else { return self }
        let localizedString = NSLocalizedString(self, comment: "")
        if args.isEmpty {
            return localizedString
        } else {
            return withVaList(args) { NSString(format: localizedString, locale: Locale.current, arguments: $0) as String }
        }
    }
    
    var formattedDate: String {
        guard let date = DateFormatter.dateFormatFromXML.date(from: self) else { return "" }
        return DateFormatter.dateFormatForView.string(from: date)
    }
}
