//
//  AlbumCell.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 02/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit
import AlamofireImage

class AlbumCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumArtist: UILabel!
    
    var hasDetail = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView.layer.cornerRadius = 5.0
        self.imageView.clipsToBounds = true
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageView.af_cancelImageRequest()
        self.imageView.image = nil
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
    
    public func setImage (_ url: URL, hadDetail: Bool? = nil) {
        
        self.imageView.af_setImage(withURL: url, placeholderImage: UIImage(named: "loading_misc")!, completion: {
            response in
            
            if let _ = response.result.value {
                
                if let hadDetail = hadDetail {
                    if !hadDetail && self.hasDetail {
                        
                    }
                }
                
        
            } else {
               self.setImage(UIImage(named: "no_media")!)
            }
        })
        
     /*   if !hasDetail {
            self.imageView.image = image.alpha(0.3)
        } else {
            self.imageView.image = image
        } */
    }
    
    func unsetTransparencyAnimated() {
        
        if let image = self.imageView.image {
            UIView.animate(withDuration: 0.5,
                           delay: 0.1,
                           options: UIViewAnimationOptions.curveEaseIn,
                           animations: { () -> Void in
                            self.imageView.image = image.alpha(1)
            }, completion: { (finished) -> Void in
            })
        }
        
    }
}
