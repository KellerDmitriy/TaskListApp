//
//  TaskListViewController.swift
//  TaskListApp
//
//  Created by Келлер Дмитрий on 20.05.2023.
//

import UIKit
import CoreData
protocol NewTaskViewControllerDelegate: AnyObject {
    func reloadData()
}

final class TaskListViewController: UITableViewController {
    private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let cellID = "cell"
    private var taskList: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        view.backgroundColor = .white
        setupNavigationBar()
        fetchData()
    }
    
    // MARK: - UITableViewDasaSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
    
    
    @objc private func addTask() {
        let newTaskVC = NewTaskViewController()
        newTaskVC.delegate = self
        present(newTaskVC, animated: true)
    }
    
    private func fetchData() {
        let fetchRequest = Task.fetchRequest()
        
        do {
            taskList = try viewContext.fetch(fetchRequest)
        } catch {
            print( error.localizedDescription)
        }
    }
}


// MARK - SetupUI
extension TaskListViewController {
    
    func setupNavigationBar() {
        title = "Task List"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor(named: "MilkPerl")
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor .white]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addTask)
        )
        navigationController?.navigationBar.tintColor = .white
    
    }
}
//MARK: - NewTaskViewControllerDelegate
extension TaskListViewController: NewTaskViewControllerDelegate {
    func reloadData() {
        fetchData()
        tableView.reloadData()
    }
    
    
}
