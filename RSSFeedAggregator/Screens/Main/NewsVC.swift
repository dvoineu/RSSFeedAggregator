//
//  NewsVC.swift
//  RSSFeedAggregator
//
//  Created by dvoineu on 3.12.24.
//

import UIKit
import CoreData

final class NewsVC: UIViewController {
    
    private let rssParser: RSSParser = RSSParser()
    var viewModel: MainVCViewModelType?
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var refreshControl = UIRefreshControl()
    let reachability = NetworkReachability()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        viewModel = FeedViewModel()
        
        setupTableView()
        
        updateNews()
    }
    
    private func updateNews() {
        
        if reachability.isConnected {
            print("Internet Connection Available!")
            guard let url = viewModel?.currentSource.url else { return }
            refreshControl.beginRefreshing()
            rssParser.updateNews(currentSource: url) {[weak self] (objects) in
                self?.viewModel?.news = objects
                self?.tableView.reloadData()
            }
            refreshControl.endRefreshing()
        } else {
            print("Internet Connection not Available!")
            guard let news = CoreDataManager.shared.loadNews() else { return }
            viewModel?.news = news
        }
    }
    
    
    @objc func refresh(_ sender: AnyObject) {
        updateNews()
    }

    // Установка UITableView
    private func setupTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        setupConstraints()
        tableView.addSubview(refreshControl)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.reuseId)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Потяните для обновления")
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        setupConstraints()
    }
    
    // Установка Constraint для UITableView
    private func setupConstraints() {
        tableView.fillToSuperView(view: view)
    }
}

extension NewsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseId, for: indexPath) as? NewsTableViewCell, let viewModel = viewModel else { return UITableViewCell() }
        
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        cell.viewModel = cellViewModel
        
        return cell
    }
}

extension NewsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailNewsVC()
        viewModel?.news[indexPath.row].isReading = true
        tableView.reloadData()
        detailVC.rssItem = viewModel?.news[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
