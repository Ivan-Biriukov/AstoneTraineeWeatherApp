// MARK: - Imports
import Foundation
import CoreData

// MARK: - SavingManager
final class SavingManager {
    
    // MARK: - Properties
    static let shared = SavingManager()
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
}

// MARK: - Public Methods
extension SavingManager {

}
