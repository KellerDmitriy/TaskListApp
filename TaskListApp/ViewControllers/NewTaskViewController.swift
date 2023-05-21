//
//  NewTaskViewController.swift
//  TaskListApp
//
//  Created by Келлер Дмитрий on 21.05.2023.
//

import UIKit
import CoreData

protocol ButtonFactory {
    func createButton () -> UIButton
}

final class FilledButtonFactory: ButtonFactory {
    let title: String
    let color: UIColor
    let action: UIAction
    
    init(title: String, color: UIColor, action: UIAction) {
    self.title = title
    self.color = color
    self.action = action
}
    func createButton() -> UIButton {
        var attributes = AttributeContainer()
        attributes.font = UIFont.boldSystemFont(ofSize: 18)
        
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseBackgroundColor = color
        buttonConfiguration.attributedTitle = AttributedString(title, attributes: attributes)
        
        let button = UIButton(configuration: buttonConfiguration, primaryAction: action)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
}


final class NewTaskViewController: UIViewController {
    weak var delegate: NewTaskViewControllerDelegate!
    private let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    lazy var taskTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle =  .roundedRect
        textField.placeholder = "New Task"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var saveButton: UIButton = {
      let filledButtonFactory = FilledButtonFactory(
        title: "Save Task",
        color: UIColor(named: "MilkPerl") ?? .systemPurple,
        action: UIAction { [unowned self] _ in
            save()
        }
      )
        return filledButtonFactory.createButton()
    }()
    
    lazy var cancelButton: UIButton = {
        let filledButtonFactory = FilledButtonFactory(
            title: "Cancler",
            color: UIColor(named: "MilkPink") ?? .systemPink,
            action: UIAction { [unowned self] _ in
                dismiss(animated: true)
            }
        )
        return filledButtonFactory.createButton()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews(taskTextField, saveButton, cancelButton)
        setConstraints()
    }
    
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            taskTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            taskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            taskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
        
        NSLayoutConstraint.activate([
          saveButton.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 20),
          saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
          saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
        
        NSLayoutConstraint.activate([
         cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
         cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
         cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
    }
    
    private func save() {
        let task = Task(context: viewContext)
        task.title = taskTextField.text
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
        delegate.reloadData()
        dismiss(animated: true)
    }
}

