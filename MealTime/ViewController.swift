//
//  ViewController.swift
//  MealTime
//
//  Created by Oleg Kanatov on 15.09.21.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate {
    
    private let headImage = UIImageView()
    private let tableView = UITableView()
    
    var context : NSManagedObjectContext!
    var user: User!
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userName = "Max"
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", userName)
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                user = User(context: context)
                user.name = userName
                try context.save()
            } else {
                user = results.first
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
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
        
        let meal = Meal(context: context)
        meal.date = Date()
        
        let meals = user.meals?.mutableCopy() as? NSMutableOrderedSet
        meals?.add(meal)
        user.meals = meals
        
        do {
            try context.save()
            tableView.reloadData()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
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
        return user.meals?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        guard let meal = user.meals?[indexPath.row] as? Meal,
              let mealDate = meal.date
        else { return cell }
        
        cell.textLabel!.text = dateFormatter.string(from: mealDate)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let meal = user.meals?[indexPath.row] as? Meal, editingStyle == .delete else { return }
        
        context.delete(meal)
        
        do {
            try context.save()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
}
