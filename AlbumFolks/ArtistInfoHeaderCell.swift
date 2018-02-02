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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    public func setContent(_ artistDetail: ArtistDetail) {
        imageView.image = UIImage(named: artistDetail.heading.photoUrl)
        infoLabel.text = artistDetail.description
        tags.text = getTagsString(artistDetail.tags)
        
        seeMore.isHidden = !tags.isTruncated
    }
    
    
    private func getTagsString(_ tags: [String]) -> String? {
        
        if tags.count == 0 {
            return nil
        } else if tags.count == 1 {
            return tags[0]
        }
        
        var formattedStr = ""
        for i in 0...tags.count-1 {
            formattedStr.append(tags[i])
            
            if i < tags.count-1 {
                formattedStr.append(", ")
            }
        }
        
        return formattedStr
        
    }
    
    @IBAction func seeMorePressed(_ sender: UIButton) {
    }
    
}
