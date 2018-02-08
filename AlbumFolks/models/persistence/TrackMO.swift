//
//  TrackMO.swift
//  AlbumFolks
//
//  Created by NTW-laptop on 06/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import CoreData
import UIKit

extension TrackMO {
    fileprivate static let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    static func createMultiple(from tracks: [TrackViewPopulator], albumMO: AlbumMO) -> Set<TrackMO>? {
        
        var set : Set<TrackMO>?
        
        for _track in tracks {
            
            if let track = create(from: _track, albumMO: albumMO) {
                if set == nil {
                    set = Set<TrackMO>()
                }
                
                set!.insert(track)
            }
        }
        
        return set
    }
    
    
    static func create(from track: TrackViewPopulator, albumMO: AlbumMO) -> TrackMO? {
        var trackToReturn : TrackMO?
        
        guard let context = albumMO.managedObjectContext else {
            return nil
        }
        
        //TODO - Change to Private?
        let childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        childContext.parent = context
        
        let entity = NSEntityDescription.entity(forEntityName: "Track",
                                                in: context)!
        
        let _track = TrackMO(entity: entity, insertInto: childContext)
        _track.album = childContext.object(with: albumMO.objectID) as? AlbumMO
        
        _track.number = Int32(track.number)
        _track.lengthStatic = track.lengthStatic
        _track.title = track.title
        
        if appDelegate.persistenceController.save(childContext) {
            trackToReturn = context.object(with: _track.objectID) as? TrackMO
        }
        
        return trackToReturn
    }
}
