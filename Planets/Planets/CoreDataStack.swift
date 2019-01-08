

import Foundation
import UIKit
import CoreData

class CoreDataStack: NSObject {
    
    
    static let sharedInstance = CoreDataStack()
    private override init() {}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        
        let container = NSPersistentContainer(name: "Planets")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    public func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    public func savePlanetsInfo(with planetBuilder: [PlanetModel]) {
        deleteAllRecords()
        let context = persistentContainer.viewContext as NSManagedObjectContext
        for names in planetBuilder {
            
            let entity = NSEntityDescription.entity(forEntityName: "Planet", in: context)
            
            let obj: Planet = Planet(entity: entity!, insertInto: context)
            obj.name = names.name
            
            self.saveContext()
        }
        
    }
    
    public func fetchPlanetsFromStore() -> [PlanetModel] {
        
        let context = persistentContainer.viewContext as NSManagedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Planet")
        request.returnsObjectsAsFaults = false
        do {
            let result: [NSManagedObject] = try context.fetch(request) as! [NSManagedObject]
            let planetsList = result.map({ (planetObj) -> PlanetModel in
                return PlanetModel(name: planetObj.value(forKey: "name") as! String)
            })
            return planetsList
            
        } catch let error {
            print("Failed with : \(error)")
        }

        return [PlanetModel]()
    }
    
    public func deleteAllRecords() {
        //getting context from your Core Data Manager Class
        let managedContext = persistentContainer.viewContext as NSManagedObjectContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Planet")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        } catch {
            print ("There is an error in deleting records")
        }
    }
}



extension CoreDataStack {
    
    func applicationDocumentsDirectory() {
        // The directory the application uses to store the Core Data store file. This code uses a directory named in the application's documents directory.
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            print(url.absoluteString)
        }
    }
}
