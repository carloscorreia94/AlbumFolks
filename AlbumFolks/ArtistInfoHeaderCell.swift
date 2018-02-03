//
//  ArtistInfoHeaderCell.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 02/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit

class ArtistInfoHeaderCell : UICollectionReusableView {
    
    
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var seeMore: UIButton!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    var artistInfoCallback : (() -> ())?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    public func setContent(_ artist: Artist) {
         imageView.image = UIImage(named: artist.photoUrl)
    }
    
    public func setDetailContent(_ detail: ArtistDetail) {
         infoLabel.text = detail.description
         tags.text = detail.getTagsString()
        
        seeMore.isHidden = !infoLabel.isTruncated
    }
    
    public func setArtistInfoCallback(_ callback: @escaping () -> ()) {
        self.artistInfoCallback = callback
    }
    
    
  
    
    @IBAction func seeMorePressed(_ sender: UIButton) {
        if let callback = artistInfoCallback {
            callback()
        }
    }
    
}
