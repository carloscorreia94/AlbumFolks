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
    
    static func get(from artist: Artist, context: NSManagedObjectContext) -> ArtistMO? {
        
        var artistToReturn : ArtistMO?
        
        //TODO - Fetch existing artist
        
        artistToReturn = create(from: artist, context: context)
        
        return artistToReturn
        
    }
    
    
    static func create(from: Artist, context: NSManagedObjectContext) -> ArtistMO? {
        
        var artistToReturn : ArtistMO?
        
        //TODO - Change to Private?
        let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        childContext.parent = context
        
        let entity = NSEntityDescription.entity(forEntityName: "Artist",
                                                in: context)!
        
        let _artist = ArtistMO(entity: entity, insertInto: childContext)
        _artist.listeners = 5
        _artist.name = ""
        _artist.photoUrl = ""
        
        if appDelegate.persistenceController.save(childContext) {
            artistToReturn = context.object(with: _artist.objectID) as? ArtistMO
        }
        
        return artistToReturn

    }
}
