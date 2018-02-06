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
    let downloader = ImageDownloader()
    var album: Album!
    
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
                }
            }
        }
        
        albumInfoHeader.albumArtist.text = album.artist.name
        albumInfoHeader.albumTags.text = album.albumDetail?.getTagsString()

        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumHeaderCell") as! AlbumHeaderCell
            return cell
        }
        return nil
    }
    
}


class TrackCell : UITableViewCell {
    @IBOutlet weak var trackNr : UILabel!
    @IBOutlet weak var name : UILabel!
    @IBOutlet weak var duration : UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        trackNr.isHidden = trackNr.text?.isEmpty ?? true
    }
}

class AlbumHeaderCell : UITableViewCell {
   
   //TODO - Delete this?
}
