//
//  PersistenceController.swift
//  AlbumFolks
//
//  Created by NTW-laptop on 06/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class PersistenceController: NSObject {

    
    fileprivate lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "AlbumFolks", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    
    init(completionClosure: (() -> ())? = nil) {
        if let closure = completionClosure {
            closure()
        }
    }
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let persistentStoreCoordinator = self.persistentStoreCoordinator
        
        // Initialize Managed Object Context
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        // Configure Managed Object Context
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        
        return managedObjectContext
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // Initialize Persistent Store Coordinator
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        // URL Documents Directory
        let URLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let applicationDocumentsDirectory = URLs[(URLs.count - 1)]
        
        // URL Persistent Store
        let URLPersistentStore = applicationDocumentsDirectory.appendingPathComponent("AlbumFolks.sqlite")
        
        do {
            // Add Persistent Store to Persistent Store Coordinator
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: URLPersistentStore, options: nil)
            
            
        } catch {
            // Populate Error
            var userInfo = [String: AnyObject]()
            userInfo[NSLocalizedDescriptionKey] = "There was an error creating or loading the application's saved data." as AnyObject?
            userInfo[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data." as AnyObject?
            
            userInfo[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "com.carlosmouracorreia.AlbumFolks", code: 1001, userInfo: userInfo)
            
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            
            abort()
        }
        
        return persistentStoreCoordinator
    }()
    
    
    func save(_ objContext: NSManagedObjectContext? = nil) -> Bool {
        do {
            if let context = objContext {
                context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                try context.save()
                
                print("saving context")
                print(context.insertedObjects)
            } else {
                try self.managedObjectContext.save()
            }
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
        return true
    }
}
