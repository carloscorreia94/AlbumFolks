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
        
        
       
        if let albumImage = albumViewPopulator.image {
            self.albumInfoHeader.imageView.image = albumImage
            self.storedImage = albumImage
        } else {
            self.albumInfoHeader.imageView.image = UIImage(named: "no_media")!
        }
        
        albumInfoHeader.albumArtist.text = albumViewPopulator.artist.name
        albumInfoHeader.albumTags.text = albumViewPopulator.tags
        
        if albumViewPopulator.localMode {
            albumInfoHeader.albumArtistSelectedCallback = enterArtist
        }

        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
    }
    
    func enterArtist() {
        //TODO - dont forget about maybe album update when coming back...
        let artistAlbumsVC = self.storyboard!.instantiateViewController(withIdentifier: "ArtistAlbumsVC") as! ArtistAlbumsVC
        
        let artist = Artist()
        artist.name = albumViewPopulator.artist.name
        artist.mbid = albumViewPopulator.artist.mbid
        artist.photoUrl = albumViewPopulator.artist.photoUrl
        artist.lastFmUrl = albumViewPopulator.artist.lastFmUrl
        
        artistAlbumsVC.artist = artist
        
        let nav = UINavigationController(rootViewController: artistAlbumsVC)
        self.present(nav, animated: true, completion: nil)
    }
    
    
    private func saveAlbum() {
        
        if albumViewPopulator.storedAlbum == nil {
            if let albumMO = AlbumMO.create(from: albumViewPopulator, withImage: storedImage) {
                albumViewPopulator.storedAlbum = albumMO
                print("Album saved!")
            }
        }
       
    }
    
    private func deleteAlbum() {
        if let album = albumViewPopulator.storedAlbum {
            if AlbumMO.delete(album: album) {
                print("Album deleted!")
            }
        }
        
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
                albumHeaderCell = tableView.dequeueReusableCell(withIdentifier: "AlbumHeaderCell") as? AlbumHeaderCell
                albumHeaderCell!.saveCallback = saveAlbum
                albumHeaderCell!.deleteCallback = deleteAlbum
                
                if let _ = albumViewPopulator.storedAlbum {
                    albumHeaderCell!.saveSwitch.setOn(true, animated: false)
                }
            }
            return albumHeaderCell!
        
    }
    
}


class AlbumHeaderCell : UITableViewCell {
   
    @IBOutlet weak var saveSwitch: UISwitch!
    var saveCallback : (() -> ())!
    var deleteCallback: (() -> ())!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        saveSwitch.addTarget(self, action: #selector(stateChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func stateChanged(switchState: UISwitch) {
        if !switchState.isOn {
            deleteCallback()
        } else {
            saveCallback()
        }
    }
}
