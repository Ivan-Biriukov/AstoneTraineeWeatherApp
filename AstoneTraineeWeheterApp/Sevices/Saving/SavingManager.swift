// MARK: - Imports
import UIKit
import CoreData

// MARK: - SavingManager
final class SavingManager {
    
    // MARK: - Properties
    static let shared = SavingManager()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
}

// MARK: - Public Methods
extension SavingManager {
    
    func saveSearchedLocation(for location: SearchCellViewModel) {
        let request: NSFetchRequest<SavedSearchedLocations> = SavedSearchedLocations.fetchRequest()
        do {
            let locs = try context.fetch(request)
            if !locs.contains(where: {$0.cityName == location.cityName}) {
                let newLocation = SavedSearchedLocations(context: self.context)
                newLocation.cityName = location.cityName
                newLocation.currentTemp = Int16(location.currentTemp)
                newLocation.dayTemp = Int32(location.dayTemp)
                newLocation.nightTepm = Int16(location.nightTepm)
                newLocation.wetherConditionImageID = location.wetherConditionImageID
                
                saveContext()
            }
        } catch {
            print(error)
        }
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
    
    func removeLocation(at row: Int, in dataArray: [SearchCellViewModel]) {
        let request: NSFetchRequest<SavedSearchedLocations> = SavedSearchedLocations.fetchRequest()
        do {
            let locs = try context.fetch(request)
                context.delete(locs[row])
                saveContext()
        } catch {
            print(error)
        }
    }
    
    func saveContext() {
        do{
            try context.save()
        } catch {
            print("Error saving Categories \(error)")
        }
    }
}

