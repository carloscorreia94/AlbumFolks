//
//  ArtistInfoHeaderCell.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 02/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit
import AlamofireImage

class ArtistInfoHeaderCell : UICollectionReusableView {
    
    
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var tags: UILabel!
    @IBOutlet weak var seeMore: UIButton!
    
    @IBOutlet weak var artistInfoStatic: UILabel!
    @IBOutlet weak var artistAlbumsStatic: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    var loadingView : UIView?
    var artistInfoCallback : (() -> ())?
    
    var imgDownloader : ImageDownloader!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    public func setContent(_ artist: Artist) {
        
        if let url = artist.photoUrl {
            let urlRequest = URLRequest(url: url)
            imgDownloader.download(urlRequest) { response in
                
                if let image = response.result.value {
                    self.imageView.image = image
                }
            }
        }
        
       
        
    }
    
    public func setDetailContent(_ detail: ArtistDetail) {
        
        if let view = loadingView {
            view.removeFromSuperview()
        }
        
        //Unhide previous hidden content (progressBar was showing)
        tags.isHidden = false
        infoLabel.isHidden = false
        artistInfoStatic.isHidden = false
        
        infoLabel.text = detail.description
        tags.text = detail.getTagsString()
        
        seeMore.isHidden = !infoLabel.isTruncated
    }
    
    public func setArtistInfoCallback(_ callback: @escaping () -> ()) {
        self.artistInfoCallback = callback
    }
    
    public func setActivityIndicatorView() {
        loadingView = LoadingIndicatorView.create(centerX: self.center.x, originY: imageView.frame.maxY + 12, size: (artistAlbumsStatic.frame.minY - imageView.frame.maxY) * 0.7)
        self.addSubview(loadingView!)
    }
    
  
    
    @IBAction func seeMorePressed(_ sender: UIButton) {
        if let callback = artistInfoCallback {
            callback()
        }
    }
    
}
