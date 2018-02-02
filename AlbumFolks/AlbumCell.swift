//
//  AlbumCell.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 02/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit

struct Album {
    let photoUrl, name, artist : String
}

class AlbumCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumArtist: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView.layer.cornerRadius = 5.0
        self.imageView.clipsToBounds = true
    }
    
    
    public func setContent(_ album: Album) {
        self.imageView.image = UIImage(named: album.photoUrl)
        self.albumName.text = album.name
        self.albumArtist.text = album.artist
    }
}
