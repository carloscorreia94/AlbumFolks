//
//  AlbumVCHeaderView.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 03/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit

class AlbumVcHeaderView : UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var albumArtist: UILabel!
    @IBOutlet weak var albumTags: UILabel!
    
    
    override func layoutSubviews() {
        imageView.contentMode = .scaleAspectFill
    }
}
