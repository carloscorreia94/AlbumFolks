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
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        imageView.clipsToBounds = true
    }
}
