//
//  AlbumVC.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 03/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit
import AlamofireImage
/**
 * Again, I didn't subclass UITableViewController as it makes it more flexible to change the layout/incrementally add more components starting with an embedded UITableView in a blank ViewController
 **/
class AlbumVC : UIViewController {
    
    @IBOutlet var albumInfoHeader: AlbumVcHeaderView!
    @IBOutlet weak var tableView : UITableView!
    fileprivate var albumHeaderCell : AlbumHeaderCell?
    fileprivate var storedImage : UIImage?
    
    var albumViewPopulator: AlbumViewPopulator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = albumViewPopulator.name
        self.tableView.tableHeaderView = albumInfoHeader
       
        if let albumImage = albumViewPopulator.inMemoryImage {
            self.albumInfoHeader.imageView.image = albumImage
            self.storedImage = albumImage
        } else if let photoUrl = albumViewPopulator.photoUrl {
            self.albumInfoHeader.imageView.af_setImage(withURL: photoUrl, placeholderImage: UIImage(named: "loading_misc")!, completion: {
                [unowned self] response in
                
                if response.result.value == nil {
                    self.albumInfoHeader.imageView.image = UIImage(named: "no_media")!
                } else if self.albumViewPopulator.localMode {
                    /* If we ever get here it means we have a local stored album with Image Url reference just downloaded (couldn't save before)
                     and so we try to save it */
                    let _ = AlbumMO.saveAlbumImage(response.result.value!, identifier: self.albumViewPopulator.hashString)
                }
                
            })
        } else {
            self.albumInfoHeader.imageView.image = UIImage(named: "no_media")!
        }
        
        albumInfoHeader.albumArtist.text = albumViewPopulator.artist.name
        albumInfoHeader.albumTags.text = albumViewPopulator.tags
        
        if albumViewPopulator.localMode {
            albumInfoHeader.albumArtistSelectedCallback = enterArtist
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Artist Page", style: .plain, target: self, action: #selector(enterArtistSelector))
        }

        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
    }
    
    @objc func enterArtistSelector(sender: UIBarButtonItem) {
        enterArtist()
    }
    
    private func enterArtist() {
        if let storedArtist = albumViewPopulator.storedAlbum?.artist {
            let artistAlbumsVC = self.storyboard!.instantiateViewController(withIdentifier: "ArtistAlbumsVC") as! ArtistAlbumsVC
            
            let artist = Artist(from: storedArtist)
            
            artistAlbumsVC.artist = artist
            artistAlbumsVC.dismissToAlbumCallback = {
                //update Saved switch when coming back from artist and having changed the same album
                self.albumHeaderCell!.saveSwitch.setOn(AlbumMO.get(from: self.albumViewPopulator.hashString) != nil, animated: false)
            }
            
            let nav = UINavigationController(rootViewController: artistAlbumsVC)
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    
    private func saveAlbum() {
        
        if albumViewPopulator.storedAlbum == nil {
            if let albumMO = AlbumMO.create(from: albumViewPopulator, withImage: storedImage) {
                albumViewPopulator.storedAlbum = albumMO
                print("Album saved!")
            } else {
                albumHeaderCell!.saveSwitch.setOn(false, animated: false)
            }
        }
       
    }
    
    private func deleteAlbum() {
        if let album = albumViewPopulator.storedAlbum {
            if AlbumMO.delete(album: album) {
                albumViewPopulator.storedAlbum = nil
                print("Album deleted!")
                return
            }
        }
        
        albumHeaderCell!.saveSwitch.setOn(true, animated: false)
        
    }

}

extension AlbumVC : UITableViewDelegate, UITableViewDataSource {
    
    // MARK : UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumViewPopulator.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackCell
        
        let track = albumViewPopulator.tracks[indexPath.row]
        
        cell.trackNr.text = String(track.number)
        cell.name.text = track.title
        cell.duration.text = track.lengthStatic
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

            if albumHeaderCell == nil {
                albumHeaderCell = tableView.dequeueReusableCell(withIdentifier: AlbumHeaderCell.REUSE_ID) as? AlbumHeaderCell
                albumHeaderCell!.saveCallback = saveAlbum
                albumHeaderCell!.deleteCallback = deleteAlbum
                
                if let _ = albumViewPopulator.storedAlbum {
                    albumHeaderCell!.saveSwitch.setOn(true, animated: false)
                }
            }
            return albumHeaderCell!
        
    }
    
}
