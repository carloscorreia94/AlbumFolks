//
//  RecentSearchMO.swift
//  AlbumFolks
//
//  Created by NTW-laptop on 08/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit
import CoreData

extension RecentSearchMO {
    fileprivate static let appDelegate = UIApplication.shared.delegate as! AppDelegate

    static func create(from artist: ArtistPopulator) -> RecentSearchMO? {
        var recentSearch : RecentSearchMO?
        
        let persistentStoreCoordinator = appDelegate.persistenceController.persistentStoreCoordinator
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        if let search = get(from: artist, context: privateContext) {
            recentSearch = search
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "RecentSearch",
                                                    in: privateContext)!
            let _search = RecentSearchMO(entity: entity, insertInto: privateContext)
            _search.artist = ArtistMO.get(from: artist, context: privateContext)
            _search.time = Date()
        }
        
        privateContext.performAndWait {
            if !appDelegate.persistenceController.save(privateContext) {
               recentSearch = nil
            }
        }
        
        return recentSearch
    }
    
    
    private static func get(from artist: ArtistPopulator, context: NSManagedObjectContext) -> RecentSearchMO? {
        var searchToReturn : RecentSearchMO?
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RecentSearch")
        request.predicate = NSPredicate(format: "artist.mbid = %@", artist.mbid)
        
        
        do {
            //we certify that we just have one
            let results = try context.fetch(request)
            if let _ : String = results.count == 1 ? "" : nil, let search = results[0] as? RecentSearchMO {
                search.time = Date()
                searchToReturn = search
            }
            
        } catch let error {
            print(error)
            return nil
        }
        
        return searchToReturn
    }
}
