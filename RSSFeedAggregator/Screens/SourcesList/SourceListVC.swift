//
//  SourceListVC.swift
//  RSSFeedAggregator
//
//  Created by dvoineu on 3.12.24.
//

import UIKit
import SnapKit

protocol SourceListDataDelegate: AnyObject {
    func updateSource(source: Source)
}

final class SourceListVC: UIViewController {
    
    // MARK: - Свойства
    private var viewModel: SourceViewModelType?
    weak var delegate: SourceListDataDelegate?
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
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
    
    private lazy var addSourceAlert: UIAlertController = {
        
        let alert = UIAlertController(title: "Добавьте RSS-источник", message: "Введите название источника и его адрес", preferredStyle: UIAlertController.Style.alert)
        
        alert.addTextField {
            $0.placeholder = "Название"
            $0.delegate = self
            $0.addTarget(alert, action: #selector(alert.textDidChangeInLoginAlert), for: .editingChanged)
        }
        
        alert.addTextField {
            $0.placeholder = "Адрес"
            $0.delegate = self
            $0.addTarget(alert, action: #selector(alert.textDidChangeInLoginAlert), for: .editingChanged)
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: UIAlertAction.Style.default, handler: {
                                    (action : UIAlertAction) -> Void in })
        
        alert.addAction(cancel)
        
        let save = UIAlertAction(title: "Сохранить", style: UIAlertAction.Style.default, handler: { saveAction -> Void in
            guard let titleTextField = alert.textFields?[0],
                  let urlTextField = alert.textFields?[1] else { return }
            
            guard let title = titleTextField.text, let url = urlTextField.text else { return }
            
            let newSource = Source(title: title, url: url, isCurrent: true)
            self.viewModel?.refreshIsCurrent()
            self.viewModel?.sources.append(newSource)
            self.tableView.reloadData()
            self.delegate?.updateSource(source: newSource)
            self.viewModel?.saveSourcesInUserDefaults()
           
            titleTextField.text = ""
            urlTextField.text = ""
            saveAction.isEnabled = false
        })
        
        save.isEnabled = false
        alert.addAction(save)
    
        return alert
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        viewModel = SourceViewModel()
        viewModel?.loadSources()
        viewModel?.setIsCurrent()
        setupTableView()
        
        let logoutBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSourceClicked(btn:)))
        self.navigationItem.rightBarButtonItem  = logoutBarButtonItem
        self.navigationItem.rightBarButtonItem?.tintColor = .link
    }
    
    // MARK: - Функции
    @objc func addSourceClicked(btn: UIBarButtonItem){
        self.present(addSourceAlert, animated: true, completion: nil)
    }
    
    private func setupTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        tableView.addSubview(emptySourceLabel)
        tableView.addSubview(emptySourceImage)
        setupConstraints()
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(SourceTableViewCell.self, forCellReuseIdentifier: SourceTableViewCell.reuseId)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptySourceLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        emptySourceLabel.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 50).isActive = true

        emptySourceImage.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        emptySourceImage.topAnchor.constraint(equalTo: emptySourceLabel.bottomAnchor, constant: 25).isActive = true
    }
}

// MARK: - UITableViewDataSource
extension SourceListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptySourceLabel.isHidden = viewModel?.numberOfRows() != 0
        emptySourceImage.isHidden = viewModel?.numberOfRows() != 0
        
       return viewModel?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
        self.viewModel?.sources.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
      }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SourceTableViewCell.reuseId, for: indexPath) as? SourceTableViewCell, let viewModel = viewModel else { return UITableViewCell() }
        
        let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        cell.viewModel = cellViewModel
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SourceListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        for i in 0..<viewModel!.sources.count {
            viewModel!.sources[i].isCurrent = false
        }
        
        viewModel!.currentSource = viewModel!.sources[indexPath.row]
        viewModel!.sources[indexPath.row].isCurrent = true
        
        tableView.reloadData()
        
        guard let newSource = viewModel?.currentSource else { return }
        self.delegate?.updateSource(source: newSource)
    }
}

// MARK: - UITextFieldDelegate
extension SourceListVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
