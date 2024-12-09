//
//  NewsVC.swift
//  RSSFeedAggregator
//
//  Created by dvoineu on 3.12.24.
//

import UIKit
import CoreData

final class NewsVC: UIViewController {
    
    // MARK: - Свойства
    private var updateTimer: Timer?
    private var updateInterval: TimeInterval {
        let frequency = UserDefaults.standard.string(forKey: "selectedFrequency") ?? "10 минут"
        switch frequency {
        case "5 минут": return 5 * 60
        case "30 минут": return 30 * 60
        case "1 час": return 60 * 60
        default: return 10 * 60
        }
    }
    
    private let rssParser: RSSParser = RSSParser()
    private var viewModel: MainVCViewModelType?
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var refreshControl = UIRefreshControl()
    let reachability = NetworkReachability()
    
    private let emptyNewsLabel: UILabel = {
        let label = UILabel()
        label.text = "Упс! Нечего показывать :)"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emptyNewsImage: UIImageView = {
        let image = #imageLiteral(resourceName: "rss-placeholder")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewModel = FeedViewModel()
        
        setupTableView()
        updateNews()
        startUpdateTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopUpdateTimer()
        
        guard let news = viewModel?.news else { return }
        
        CoreDataManager.shared.saveNews(news: news)
    }
    
    // MARK: - Функции
    
    private func updateNews() {
        viewModel?.news = []
        
        if reachability.isConnected {
            print("Internet Connection Available!")
            
            guard let data = UserDefaults.standard.data(forKey: "newsSources"),
                  let sources = try? JSONDecoder().decode([FeedSource].self, from: data) else { return }
            
            let enabledSources = sources.filter { $0.isEnabled }
            let dispatchGroup = DispatchGroup()
            var allNews = Set<Feed>()
            
            refreshControl.beginRefreshing()
            view.isUserInteractionEnabled = false
            
            for source in enabledSources {
                dispatchGroup.enter()
                rssParser.updateNews(currentSource: source.url) { items in
                    allNews.formUnion(items)
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) { [weak self] in
                guard let self = self else { return }
                
                let sortedNews = allNews.sorted { first, second in
                    guard let firstDate = DateFormatter.dateFormatFromXML.date(from: first.date ?? ""),
                          let secondDate = DateFormatter.dateFormatFromXML.date(from: second.date ?? "") else {
                        return false
                    }
                    return firstDate > secondDate
                }
                
                DispatchQueue.main.async {
                    self.viewModel?.news = sortedNews
                    self.tableView.reloadData()
                    CoreDataManager.shared.saveNews(news: sortedNews)
                    
                    self.view.isUserInteractionEnabled = true
                    self.refreshControl.endRefreshing()
                }
            }
            
        } else {
            print("Internet Connection not Available!")
            guard let news = CoreDataManager.shared.loadNews() else { return }
            
            guard let data = UserDefaults.standard.data(forKey: "newsSources"),
                  let sources = try? JSONDecoder().decode([FeedSource].self, from: data) else { return }
            
            let enabledSourceUrls = sources.filter { $0.isEnabled }.map { $0.url }
            
            let filteredNews = news.filter { newsItem in
                guard let newsSource = newsItem.sourceUrl else { return false }
                return enabledSourceUrls.contains(newsSource)
            }

            viewModel?.news = filteredNews.sorted { first, second in
                guard let firstDate = DateFormatter.dateFormatFromXML.date(from: first.date ?? ""),
                      let secondDate = DateFormatter.dateFormatFromXML.date(from: second.date ?? "") else {
                    return false
                }
                return firstDate > secondDate
            }
            
            let sortedNews = news.sorted { first, second in
                guard let firstDate = DateFormatter.dateFormatFromXML.date(from: first.date ?? ""),
                      let secondDate = DateFormatter.dateFormatFromXML.date(from: second.date ?? "") else {
                    return false
                }
                return firstDate > secondDate
            }
            
            viewModel?.news = sortedNews
            tableView.reloadData()
        }
    }
    
    
    
    @objc func refresh(_ sender: AnyObject) {
        updateNews()
    }
    
    private func setupTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        tableView.addSubview(refreshControl)
        tableView.addSubview(emptyNewsLabel)
        tableView.addSubview(emptyNewsImage)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.reuseId)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Потяните для обновления")
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyNewsLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        emptyNewsLabel.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 50).isActive = true
        
        emptyNewsImage.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        emptyNewsImage.topAnchor.constraint(equalTo: emptyNewsLabel.bottomAnchor, constant: 25).isActive = true
    }
}

// MARK: - UITableViewDataSource
extension NewsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        emptyNewsLabel.isHidden = viewModel?.numberOfRows() != 0
        emptyNewsImage.isHidden = viewModel?.numberOfRows() != 0
        
        return viewModel?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseId, for: indexPath) as? NewsTableViewCell,
                  let viewModel = viewModel,
                  let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath) else {
                return UITableViewCell()
            }
            
            cell.viewModel = cellViewModel
            return cell
        }
}

// MARK: - UITableViewDelegate
extension NewsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        let detailVC = DetailNewsVC()
        viewModel.news[indexPath.row].isReading = true
        CoreDataManager.shared.saveNews(news: viewModel.news)
        tableView.reloadData()
        detailVC.rssItem = viewModel.news[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - SourceListDataDelegate
extension NewsVC: SourceListDataDelegate {
    func updateSource(source: Source) {
        viewModel?.currentSource = source
        updateNews()
    }
}

// MARK: - SettingsDelegate
extension NewsVC: SettingsDelegate {
    func didUpdateSources() {
        updateNews()
    }
    
    func didUpdateFrequency() {
        startUpdateTimer()
    }
}

// MARK: - Timer for news update
extension NewsVC {
    private func startUpdateTimer() {
        stopUpdateTimer()
        updateTimer = Timer.scheduledTimer(timeInterval: updateInterval,
                                         target: self,
                                         selector: #selector(autoUpdateNews),
                                         userInfo: nil,
                                         repeats: true)
    }

    private func stopUpdateTimer() {
        updateTimer?.invalidate()
        updateTimer = nil
    }

    @objc private func autoUpdateNews() {
        updateNews()
    }
}
