//
//  ViewController.swift
//  MealTime
//
//  Created by Oleg Kanatov on 15.09.21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    private let headImage = UIImageView()
    private let tableView = UITableView()
    
    var array = [Date]()
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewSetup()
        headImageSetup()
        tableViewSetup()
    }
    
    //-------------------------------------------------
    // MARK: - Content
    //-------------------------------------------------
    
    private func viewSetup() {
        self.title = "MealTime"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.add,
            target: self,
            action: #selector(addButtonPressed)
        )
    }
    
    @objc func addButtonPressed(_ sender: UIBarButtonItem) {
        let date = Date()
        array.append(date)
        tableView.reloadData()
    }
    
    private func headImageSetup() {
        headImage.image = UIImage(named: "headImage")
        headImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headImage)
        NSLayoutConstraint.activate([
            headImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headImage.heightAnchor.constraint(equalToConstant: 155)
        ])
    }
    
    private func tableViewSetup() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headImage.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}


//-------------------------------------------------
// MARK: - UITableViewDataSource
//-------------------------------------------------

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My happy meal time"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        let date = array[indexPath.row]
        
        cell!.textLabel!.text = dateFormatter.string(from: date)
        return cell!
    }
}
