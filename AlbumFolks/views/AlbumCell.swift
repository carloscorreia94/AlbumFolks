//
//  AlbumCell.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 02/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit


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
      
        if album.photoUrl == nil {
            setImage(UIImage(named: "no_media")!)
        }
                
        self.albumName.text = album.name
        self.albumArtist.text = album.artist.name
    }
    
    
    public func setContent(_ storedAlbum: AlbumMO) {
        if !storedAlbum.hasImage {
            setImage(UIImage(named: "no_media")!)
        }
        
        self.albumName.text = storedAlbum.name
        self.albumArtist.text = storedAlbum.artist!.name
    }
    
    public func setImage(_ image: UIImage) {
        self.imageView.image = image
    }
}
