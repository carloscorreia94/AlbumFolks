//
//  CoreDataHelpers.swift
//  AlbumFolksTests
//
//  Created by NTW-laptop on 18/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import CoreData

class CoreDataHelpers {
    static func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext? {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            return nil
        }
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }
}


