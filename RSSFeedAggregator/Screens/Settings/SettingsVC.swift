//
//  SettingsVC.swift
//  RSSFeedAggregator
//
//  Created by dvoineu on 4.12.24.
//

import UIKit

class SettingsVC: UIViewController {

    // MARK: - Properties
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let frequencies = ["5 минут", "10 минут", "30 минут", "1 час"]
    private let sources = ["Ведомости", "РБК"]
    
    private var selectedFrequency: String = "10 минут" // По умолчанию
    private var enabledSources: [String: Bool] = ["Ведомости": true, "РБК": true] // Источники включены по умолчанию

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - UI Setup
    private func setupUI() {
        title = "Настройки"
        view.backgroundColor = .systemBackground
        
        // TableView setup
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension SettingsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // 1: Источники новостей, 2: Частота обновления
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return sources.count // Источники новостей
        case 1: return frequencies.count // Частота обновления
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch indexPath.section {
        case 0: // Источники новостей
            let source = sources[indexPath.row]
            cell.textLabel?.text = source
            let switchControl = UISwitch()
            switchControl.isOn = enabledSources[source] ?? true
            switchControl.tag = indexPath.row
            switchControl.addTarget(self, action: #selector(toggleSource(_:)), for: .valueChanged)
            cell.accessoryView = switchControl
        case 1: // Частота обновления
            let frequency = frequencies[indexPath.row]
            cell.textLabel?.text = frequency
            cell.accessoryType = (frequency == selectedFrequency) ? .checkmark : .none
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
        case 0: return "Источники новостей"
        case 1: return "Частота обновления"
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 { // Частота обновления
            selectedFrequency = frequencies[indexPath.row]
            tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
        }
    }
}

// MARK: - Actions
extension SettingsVC {
    @objc private func toggleSource(_ sender: UISwitch) {
        let source = sources[sender.tag]
        enabledSources[source] = sender.isOn
    }
}
