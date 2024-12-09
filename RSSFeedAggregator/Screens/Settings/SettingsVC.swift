//
//  SettingsVC.swift
//  RSSFeedAggregator
//
//  Created by dvoineu on 4.12.24.
//

import UIKit

// MARK: - Source Model
struct FeedSource: Codable {
    let name: String
    let url: String
    var isEnabled: Bool
}

protocol IFeedSourceViewModel {}

protocol SettingsDelegate: AnyObject {
    func didUpdateSources()
    func didUpdateFrequency()
}

final class FeedSourceViewModel: IFeedSourceViewModel {
    
    var feedSources: [FeedSource] = []
    
    func numberOfFeedSources() -> Int {
        feedSources.count
    }
}

final class SettingsVC: UIViewController {
    
    // MARK: - Свойства
    
    weak var delegate: SettingsDelegate?
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let frequencies = ["5 минут", "10 минут", "30 минут", "1 час"]
    private var sources: [FeedSource] {
        get {
            guard let data = UserDefaults.standard.data(forKey: "newsSources"),
                  let sources = try? JSONDecoder().decode([FeedSource].self, from: data) else {
                return []
            }
            return sources
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: "newsSources")
            }
        }
    }
    
    private var selectedFrequency: String {
        get {
            return UserDefaults.standard.string(forKey: "selectedFrequency") ?? "10 минут"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "selectedFrequency")
        }
    }
    
    private let emptySourceLabel: UILabel = {
        let label = UILabel()
        label.text = "Кажется у Вас нет еще источников новостей\n Добавьте их!"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emptySourceImage: UIImageView = {
        let image = UIImage(named: "rss-placeholder")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSourceClicked))
        navigationItem.rightBarButtonItem = addBarButton
        navigationItem.rightBarButtonItem?.tintColor = .link
        
        setupUI()
    }

    // MARK: - UI Setup
    private func setupUI() {
        title = "Настройки"
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Добавление источника
        @objc private func addSourceClicked() {
            let alert = UIAlertController(title: "Добавьте RSS-источник", message: "Введите название и URL", preferredStyle: .alert)
            
            alert.addTextField { textField in
                textField.placeholder = "Название"
            }
            alert.addTextField { textField in
                textField.placeholder = "URL"
            }
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
            let saveAction = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
                guard let self = self else { return }
                guard let name = alert.textFields?[0].text, !name.isEmpty,
                      let url = alert.textFields?[1].text, !url.isEmpty else {
                    return
                }
                
                let newSource = FeedSource(name: name, url: url, isEnabled: true)
                self.sources.append(newSource) // Добавляем новый источник
                tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
                self.saveSourcesToUserDefaults()
                self.delegate?.didUpdateSources()
            }
            
            alert.addAction(cancelAction)
            alert.addAction(saveAction)
            present(alert, animated: true)
        }
        
        // MARK: - Сохранение источников в UserDefaults
        private func saveSourcesToUserDefaults() {
            let encoder = JSONEncoder()
            if let encodedData = try? encoder.encode(sources) {
                UserDefaults.standard.set(encodedData, forKey: "newsSources")
            }
        }
}


// MARK: - UITableViewDataSource
extension SettingsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return frequencies.count
        case 1: return sources.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.accessoryType = .none
        cell.accessoryView = nil
        
        switch indexPath.section {
        case 0:
            let frequency = frequencies[indexPath.row]
            cell.textLabel?.text = frequency
            cell.accessoryType = (frequency == selectedFrequency) ? .checkmark : .none
        case 1:
            if sources.isEmpty {
                cell.textLabel?.text = "Нет источников"
                cell.selectionStyle = .none
            } else {
                let source = sources[indexPath.row]
                cell.textLabel?.text = source.name
                let switchControl = UISwitch()
                switchControl.isOn = source.isEnabled
                switchControl.tag = indexPath.row
                switchControl.addTarget(self, action: #selector(toggleSource(_:)), for: .valueChanged)
                cell.accessoryView = switchControl
            }
            
        default:
            break
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Частота обновления"
        case 1: return "Источники новостей"
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            selectedFrequency = frequencies[indexPath.row]
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            delegate?.didUpdateFrequency()
        }
    }
    
    // MARK: - Удаление источника с подтверждением
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && editingStyle == .delete { // Удаление только в разделе источников
            let sourceToRemove = sources[indexPath.row]
            
            let alert = UIAlertController(
                title: "Удалить источник",
                message: "Вы уверены, что хотите удалить источник \"\(sourceToRemove.name)\"?",
                preferredStyle: .alert
            )
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
            let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                
                self.sources.remove(at: indexPath.row)
                self.saveSourcesToUserDefaults()
                
                tableView.deleteRows(at: [indexPath], with: .fade) // Анимация удаления
                self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
            }
            
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            present(alert, animated: true)
        }
    }
}

// MARK: - Actions
extension SettingsVC {
    @objc private func toggleSource(_ sender: UISwitch) {
        sources[sender.tag].isEnabled = sender.isOn
        saveSourcesToUserDefaults()
        delegate?.didUpdateSources()
    }
}

extension SettingsVC {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 0 {
            return .none
        } else {
            return .delete
        }
    }
}
