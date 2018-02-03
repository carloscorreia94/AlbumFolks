//
//  ArtistCell.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 02/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit

class ArtistCell : UITableViewCell {
    
    @IBOutlet weak var artistName : UILabel!
    @IBOutlet weak var genderSlashStored : UILabel!
    @IBOutlet weak var customImageView : UIImageView!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        customImageView.layer.cornerRadius = customImageView.bounds.size.width / 2
        customImageView.clipsToBounds = true
        customImageView.contentMode = .scaleAspectFill

    }
    
    public func setContent(_ artist: Artist) {
        self.customImageView.image = UIImage(named: artist.photoUrl)
        self.artistName.text = artist.name
        self.genderSlashStored.text = artist.gender
    }
}
