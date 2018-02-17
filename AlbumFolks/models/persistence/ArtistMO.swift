//
//  ArtistMO.swift
//  AlbumFolks
//
//  Created by NTW-laptop on 06/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import CoreData
import UIKit


extension ArtistMO {
    fileprivate static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func getLastFmUrl() -> URL? {
        if let urlString = self.lastFmUrl {
            return URL(string: urlString)
        }
        return nil
    }
    
    func getPhotoUrl() -> URL? {
        if let urlString = self.photoUrl {
            return URL(string: urlString)
        }
        return nil
    }
    
    static func get(from artist: ArtistViewPopulator, context: NSManagedObjectContext) -> ArtistMO? {
        
        var artistToReturn : ArtistMO?
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Artist")
        request.predicate = NSPredicate(format: "mbid = %@", artist.name)
        
        
        do {
            //we certify that we just have one artist
            let results = try context.fetch(request)
            if let _ : String = results.count == 1 ? "" : nil, let artist = results[0] as? ArtistMO {
                artistToReturn = artist
            } else {
                artistToReturn = create(from: artist, context: context)
            }
            
        } catch let error {
            print(error)
            return nil
        }
        
        return artistToReturn
        
    }
    
    
    static func create(from artist: ArtistViewPopulator, context: NSManagedObjectContext) -> ArtistMO? {
        
        var artistToReturn : ArtistMO?
        
        let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        childContext.parent = context
        
        let entity = NSEntityDescription.entity(forEntityName: "Artist",
                                                in: context)!
        
        let _artist = ArtistMO(entity: entity, insertInto: childContext)
        _artist.name = artist.name
        _artist.photoUrl = artist.photoUrl?.absoluteString
        _artist.mbid = artist.mbid
        _artist.lastFmUrl = artist.lastFmUrl?.absoluteString
        
        if appDelegate.persistenceController.save(childContext) {
            artistToReturn = context.object(with: _artist.objectID) as? ArtistMO
        }
        
        return artistToReturn

    }
}
