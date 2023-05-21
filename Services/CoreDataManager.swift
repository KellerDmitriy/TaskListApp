//
//  CoreDataManager.swift
//  TaskListApp
//
//  Created by Келлер Дмитрий on 21.05.2023.
//

import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var viewContext = persistentContainer.viewContext
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskListApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as? NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        guard viewContext.hasChanges else { return }
        do {
            try viewContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func fetchTask() -> [Task] {
        let fetchRequest = Task.fetchRequest()
        do {
            return  try viewContext.fetch(fetchRequest)
        } catch {
            print( error.localizedDescription)
            return []
        }
    }
    
    func edit(_ task: Task, newTitle: String) {
        task.title = newTitle
        saveContext()
    }
    
    func delete(_ object: Task) {
        viewContext.delete(object)
        saveContext()
    }
}
