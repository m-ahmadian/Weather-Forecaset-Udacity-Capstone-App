//
//  DataController.swift
//  Weather Forecast
//
//  Created by Mehrdad Ahmadian on 2021-09-06.
//

import Foundation
import CoreData

class DataController {
    let persistentContainer: NSPersistentContainer!

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // Create a bakground context in case of slow work to free up and untie the main queue
    // Both main queue and private queue contexts with their merge policy are created, so any further development could be built upon this Core Data Stack
    var backgroundContext: NSManagedObjectContext!

    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }

    func configureContexts() {
        backgroundContext = persistentContainer.newBackgroundContext()

        viewContext.automaticallyMergesChangesFromParent = true
        backgroundContext.automaticallyMergesChangesFromParent = true

        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }

    // function to load persistent store and call configure contexts (main and private)
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescripion, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            // self.atoSaveViewContext()
            self.configureContexts()
            completion?()
        }
    }
}

extension DataController {
    // A method to save the context automatically at regular intervals if there are changes, in case of unexpected app termination
    func autoSaveViewContext(interval: TimeInterval = 60) {
        print("autosaving")
        guard interval > 0 else {
            print("Cannot set negative value to autosave interval!")
            return
        }

        if viewContext.hasChanges {
            try? viewContext.save()
        }
        DispatchQueue.main.async {
            self.autoSaveViewContext(interval: interval)
        }
    }
}
