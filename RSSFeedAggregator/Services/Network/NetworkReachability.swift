//
//  NetworkReachability.swift
//  RSSFeedAggregator
//
//  Created by dvoineu on 3.12.24.
//

import Network

class NetworkReachability {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)

    var isConnected: Bool {
        return monitor.currentPath.status == .satisfied
    }

    init() {
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
