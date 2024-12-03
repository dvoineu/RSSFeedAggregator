//
//  UIView+Extension.swift
//  RSSFeedAggregator
//
//  Created by dvoineu on 3.12.24.
//

import UIKit

extension UIView {
    
    ///Закругляет два верхних края для UIView
    ///
    /// - Parameters:
    ///     - cornerRadius: Радиус закругления
    func roundCorners(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
