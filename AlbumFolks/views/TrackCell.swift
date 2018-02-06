//
//  TrackCell.swift
//  AlbumFolks
//
//  Created by NTW-laptop on 06/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit

class TrackCell : UITableViewCell {
    @IBOutlet weak var trackNr : UILabel!
    @IBOutlet weak var name : UILabel!
    @IBOutlet weak var duration : UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        trackNr.text = (trackNr.text ?? "") == "" ? "" : trackNr?.text
    }
}
