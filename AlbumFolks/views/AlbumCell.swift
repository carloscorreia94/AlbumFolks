//
//  AlbumCell.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 02/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit
import AlamofireImage

class AlbumCell : UICollectionViewCell, CAAnimationDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumArtist: UILabel!
    @IBOutlet weak var storedLabel: UILabel!
    
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
        
        self.imageView.layer.borderColor = nil
        self.imageView.layer.borderWidth = 0.0
    }
    
    public func setContent(_ album: Album) {
      
        if album.photoUrl == nil {
            setImage(UIImage(named: "no_media")!)
        }
                
        self.albumName.text = album.name
        self.albumArtist.text = album.artist.name
    }
    
    public func setSearchCellContent() {
        setImage(UIImage(named: "add_album")!)
        self.imageView.layer.borderColor = UIColor.black.cgColor
        self.imageView.layer.borderWidth = 3.0
        self.albumName.text = "Last FM API"
        self.albumArtist.text = "Search Albums"
    }
    
    public func setContent(_ storedAlbum: AlbumMO) {
        if !storedAlbum.hasImage {
            setImage(UIImage(named: "no_media")!)
        }
        
        self.albumName.text = storedAlbum.name
        self.albumArtist.text = storedAlbum.artist!.name
    }
    
    public func setImage(_ image: UIImage) {
        //nothing to encapsulate for now. but was handy before, can be afterwards
        self.imageView.image = image
    }
    
    public func setImage (_ url: URL?, hadDetail: Bool, completion: ((UIImage?) -> ())? = nil ) {
        
        if let url = url {
            self.imageView.af_setImage(withURL: url, placeholderImage: UIImage(named: "loading_misc")!, completion: {
                response in
                
                if let _image = response.result.value {
                    self.setImage(_image)
                    completion?(_image)
                    
                    if !hadDetail && self.hasDetail {
                        self.unsetTransparencyAnimated()
                        
                    } else {
                        self.imageView.alpha = !self.hasDetail ? 0.3 : 1.0
                    }
                            
                } else {
                    self.setNoMediaImage(hadDetail: hadDetail)
                }
            })
        } else {
            setNoMediaImage(hadDetail: hadDetail)
        }
        
        
        
    }
    
    private func setNoMediaImage(hadDetail: Bool) {
        let image = UIImage(named: "no_media")!
        self.setImage(image)
        
        if !hadDetail && self.hasDetail {
            unsetTransparencyAnimated()
        } else {
            self.imageView.alpha = !self.hasDetail ? 0.3 : 1.0
        }
        
        
    }
    
    private func unsetTransparencyAnimated() {
        self.imageView.alpha = 0.3
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "opacity");
        animation.delegate = self
        animation.fromValue = 0.3
        animation.toValue = 1
        animation.duration = 0.4
        self.imageView.layer.add(animation, forKey: nil)
        self.imageView.alpha = 1.0
    }
}

