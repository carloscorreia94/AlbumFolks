//
//  AlbumMO.swift
//  AlbumFolks
//
//  Created by NTW-laptop on 06/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import CoreData
import UIKit

extension AlbumMO {
    
    fileprivate static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    private static func saveAlbumImage(_ image: UIImage, identifier: String) -> URL? {
        return ImageFileUtils.saveImage(image: image, path: String(format: FileUtils.ALBUM_FILE,identifier), folder: FileUtils.ALBUMS_FOLDER)
    }
    
    func getLocalImageURL() -> URL? {
        return self.hasImage ? FileUtils.getFile(name: String(format: FileUtils.ALBUM_FILE, self.stringHash!), folder: FileUtils.ALBUMS_FOLDER) : nil
    }
    
    func getLocalImagePathString() -> String? {
        return getLocalImageURL()?.path ?? nil
    }
    
    static func get(from stringHash: String) -> AlbumMO? {
        let context = appDelegate.persistenceController.managedObjectContext
        context.refreshAllObjects()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
        request.predicate = NSPredicate(format: "stringHash = %@", stringHash)
        
        
        do {
            let results = try context.fetch(request)
            if let _ : Int? = results.count == 1 ? 1 : nil, let result = results[0] as? AlbumMO {
                return result
            } else {
                return nil
            }
        } catch let error {
            print(error)
            return nil
        }
    }
    
    static func delete(album: AlbumMO) -> Bool {
        var ok = false
        
        let persistentStoreCoordinator = appDelegate.persistenceController.persistentStoreCoordinator
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        let albumToDelete = privateContext.object(with: album.objectID) as! AlbumMO
        let imageURL = albumToDelete.getLocalImageURL()
        
        privateContext.performAndWait {
            
            privateContext.delete(albumToDelete)
            if appDelegate.persistenceController.save(privateContext) {
                if let url = imageURL {
                    let _ = FileUtils.deleteFile(file: url)
                }
                ok = true
            }
        }
        
        return ok
    }
    

    static func create(from album: AlbumViewPopulator, withImage: UIImage? = nil) -> AlbumMO? {
        var albumToReturn : AlbumMO?
        
        let persistentStoreCoordinator = appDelegate.persistenceController.persistentStoreCoordinator
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        guard let artist = ArtistMO.get(from: album.artist, context: privateContext) else {
            return nil
        }
        
        
            
            var imageURL : URL?
            
            /*
            * We don't save imageURL but instead a boolean (hasImage) so we can fetch the file dynamically.
            */
            if let image = withImage, let url = saveAlbumImage(image, identifier: album.hashString) {
                imageURL = url
            }
            
            let entity = NSEntityDescription.entity(forEntityName: "Album",
                                                    in: privateContext)!
            let _album = AlbumMO(entity: entity, insertInto: privateContext)
            _album.artist = artist
            artist.addToAlbums(_album)
            
            _album.name = album.name
            _album.stringHash = album.hashString
            _album.hasImage = imageURL != nil
            _album.tags = album.tags
            _album.storedDate = Date()

            if let tracks = TrackMO.createMultiple(from: album.tracks, albumMO: _album) {
                _album.addToTracks(tracks as NSSet)
            } else {
                return nil
            }
            
            privateContext.performAndWait {
                if appDelegate.persistenceController.save(privateContext) {
                    albumToReturn = _album
                
                //In case we can't save and already saved the image File
                } else if let url = imageURL {
                    let _ = FileUtils.deleteFile(file: url)
                }
            }
        
        
        return albumToReturn

    }
}
