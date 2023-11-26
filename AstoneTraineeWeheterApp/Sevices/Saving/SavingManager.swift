// MARK: - Imports
import Foundation
import CoreData

// MARK: - SavingManager
final class SavingManager {
    
    // MARK: - Properties
    static let shared = SavingManager()
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SavedSearchedLocations")
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
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// MARK: - Public Methods
extension SavingManager {
    
    func saveSearchedLocation(location: SearchCellViewModel, completion: @escaping (Result<Bool, Error>) -> Void) {
        let newLocation = SavedSearchedLocations(context: self.context)
        newLocation.cityName = location.cityName
        newLocation.currentTemp = Int16(location.currentTemp)
        newLocation.dayTemp = Int32(location.dayTemp)
        newLocation.nightTepm = Int16(location.nightTepm)
        newLocation.wetherConditionImageID = location.wetherConditionImageID
        
        saveContext()
//        do {
//            try context.save()
//            completion(.success(true))
//        } catch {
//            completion(.failure(error))
//        }
    }
    
    func loadSavedLocations() -> [SearchCellViewModel] {
        let request: NSFetchRequest<SavedSearchedLocations> = SavedSearchedLocations.fetchRequest()
        var tempLocations: [SearchCellViewModel] = []
        
        do {
            let locs = try context.fetch(request)
            for loc in locs {
                tempLocations.append(SearchCellViewModel(cityName: loc.cityName!, dayTemp: Int(loc.dayTemp), nightTepm: Int(loc.nightTepm), wetherConditionImageID: loc.wetherConditionImageID!, currentTemp: Int(loc.currentTemp)))
            }
        } catch {
            print(error)
            tempLocations = []
        }
        return tempLocations
    }
    
    func removeLocation(at row: Int) {
        
    }
}

