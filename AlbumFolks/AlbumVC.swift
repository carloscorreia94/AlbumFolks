//
//  AlbumVC.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 03/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit

/**
 * Again, I didn't subclass UITableViewController as it makes it more flexible to change the layout/incrementally add more components starting with an embedded UITableView in a blank ViewController
 **/
class AlbumVC : UIViewController {
    
    @IBOutlet var albumInfoHeader: AlbumVcHeaderView!
    @IBOutlet weak var tableView : UITableView!

    var albumDetail : AlbumDetail!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Salad Days"
        
        self.tableView.tableHeaderView = albumInfoHeader
        
        albumInfoHeader.imageView.image = UIImage(named: albumDetail.album.photoUrl)
        albumInfoHeader.albumArtist.text = albumDetail.artist.name
        albumInfoHeader.albumYear.text = albumDetail.year

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
        return albumDetail.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackCell
        
        let track = albumDetail.tracks[indexPath.row]
        
        cell.trackNr.text = "\(track.id)"
        cell.name.text = track.name
        cell.duration.text = track.duration
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumHeaderCell") as! AlbumHeaderCell
        
        return cell
    }
    
}


class TrackCell : UITableViewCell {
    @IBOutlet weak var trackNr : UILabel!
    @IBOutlet weak var name : UILabel!
    @IBOutlet weak var duration : UILabel!
}

class AlbumHeaderCell : UITableViewCell {
   
}
