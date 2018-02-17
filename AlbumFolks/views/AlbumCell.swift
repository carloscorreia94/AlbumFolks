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
    
    var hasDetail = true
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView.layer.cornerRadius = 5.0
        self.imageView.clipsToBounds = true
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
                
        self.imageView.layer.borderColor = nil
        self.imageView.layer.borderWidth = 0.0
    }
    
    public func setContent(_ album: Album) {
      
        if album.photoUrl == nil {
            setImageFrom(image: UIImage(named: "no_media")!)
        }
                
        self.albumName.text = album.name
        self.albumArtist.text = album.artist.name
    }
    
    public func setSearchCellContent() {
        setImageFrom(image: UIImage(named: "add_album")!)
        self.imageView.layer.borderColor = UIColor.black.cgColor
        self.imageView.layer.borderWidth = 3.0
        self.albumName.text = "Last FM API"
        self.albumArtist.text = "Search Albums"
    }
    
    public func setContent(_ storedAlbum: AlbumMO) {
        if storedAlbum.photoUrl == nil {
            setImageFrom(image: UIImage(named: "no_media")!)
        }
        
        self.albumName.text = storedAlbum.name
        self.albumArtist.text = storedAlbum.artist!.name
    }
    
    public func setImageFrom(image: UIImage, hadDetail: Bool = true) {
        self.imageView.image = image
       
        if !hadDetail && self.hasDetail {
            self.unsetTransparencyAnimated()
            
        } else {
            self.imageView.alpha = !self.hasDetail ? 0.3 : 1.0
        }
    }
    
    public func setImageFrom(url: URL?, hadDetail: Bool, completion: @escaping (UIImage) -> ()) {
        
        if let url = url {
            self.imageView.af_setImage(withURL: url, placeholderImage: UIImage(named: "loading_misc")!, completion: {
                response in
                
                if let _image = response.result.value {
                    self.setImageFrom(image: _image, hadDetail: hadDetail)
                    completion(_image)
                    
                            
                } else {
                    print("Error loading image for url: \(url.absoluteString)")
                    self.setNoMediaImage(hadDetail: hadDetail)
                }
            })
        } else {
            setNoMediaImage(hadDetail: hadDetail)
        }
        
        
        
    }
    
    private func setNoMediaImage(hadDetail: Bool) {
        let image = UIImage(named: "no_media")!
        self.setImageFrom(image: image, hadDetail: hadDetail)
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

