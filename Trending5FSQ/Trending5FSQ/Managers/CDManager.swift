//
//  CDManager.swift
//  Trending5FSQ
//
//  Created by Branko Popovic on 12/20/19.
//  Copyright © 2019 Branko Popovic. All rights reserved.
//

import Foundation
import CoreData

class CDManager: NSObject {
    static let shared = CDManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Trending5FSQ")
        
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
    
    func saveContext () {
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
}

extension CDManager {
    func fetchVenues(completion:@escaping ([Venue]?)->Void) {
        let managedCtx = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Venue")
        fetchRequest.fetchLimit = 5
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        do {
            let result = try managedCtx.fetch(fetchRequest) as? [Venue]
            completion(result)
        }
        catch {
            completion(nil)
            print("Fetch fialed")
        }
    }
}

extension CDManager {
    func update(venueWithId id: String, address: String, category: String, name: String, distance: Int64)->Venue? {
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName:"Venue")
        fetchReq.predicate = NSPredicate(format: "fsqId = %@", id)
        
        do {
            let context = persistentContainer.viewContext
            if let persisted = try context.fetch(fetchReq).first as? Venue {
                persisted.timestamp = Date()
                persisted.address = address
                persisted.category = category
                persisted.distance = distance
                persisted.name = name
                return persisted
            }
        }
        catch {
            print("Update error")
            return nil
        }
        return nil
    }
}
