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
    fileprivate let downloader = ImageDownloader()
    var album: Album!
    
    /* TODO - NO MEDIA FUNCTION */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = album.name
        
        self.tableView.tableHeaderView = albumInfoHeader
        
        /*
        * I'm not sure about the caching mechanism with AlamofireImage. Am to in a hurry to finish this so didn't went to the trouble of storing potentially a lot of data in memory for UIImages. Anyways, images are stored for savedAlbums.
        */
        if let albumImageUrl = album.photoUrl {
            let urlRequest = URLRequest(url: albumImageUrl)
            
            downloader.download(urlRequest) { [unowned self] response in
                
                if let image = response.result.value {
                    self.albumInfoHeader.imageView.image = image
                } else {
                    self.albumInfoHeader.imageView.image = UIImage(named: "no_media")!
                }
            }
        } else {
            self.albumInfoHeader.imageView.image = UIImage(named: "no_media")!
        }
        
        albumInfoHeader.albumArtist.text = album.artist.name
        albumInfoHeader.albumTags.text = album.albumDetail?.getTagsString()

        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
    }
    
    
    func saveAlbum() {
        if let _ = AlbumMO.create(from: album) {
            print("Album saved!")
        } else {
            albumHeaderCell!.saveSwitch.setOn(false, animated: true)
        }
    }

}

extension AlbumVC : UITableViewDelegate, UITableViewDataSource {
    
    // MARK : UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album.albumDetail?.tracks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackCell
        
        guard let track = album.albumDetail?.tracks[indexPath.row] else {
            fatalError("Invalid application state on AlbumVC - dequeing cell.")
        }
        
        cell.trackNr.text = String(track.number)
        cell.name.text = track.title
        cell.duration.text = track.lengthStatic
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tracks = album.albumDetail?.tracks.count ?? 0

        //ISSUE - Design : Should I be able to store an album with 0 tracks?
        if tracks > 0 {
            if albumHeaderCell == nil {
                albumHeaderCell = tableView.dequeueReusableCell(withIdentifier: "AlbumHeaderCell") as? AlbumHeaderCell
                albumHeaderCell!.saveCallback = saveAlbum
            }
            return albumHeaderCell!
        }
        return nil
    }
    
}


class AlbumHeaderCell : UITableViewCell {
   
    @IBOutlet weak var saveSwitch: UISwitch!
    var saveCallback : (() -> ())!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        saveSwitch.addTarget(self, action: #selector(stateChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func stateChanged(switchState: UISwitch) {
        if switchState.isOn {
            saveCallback()
        }
    }
}
