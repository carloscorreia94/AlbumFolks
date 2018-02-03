//
//  AlbumsViewController.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 02/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit
import PopupDialog

class ArtistAlbumsVC : UIViewController, UICollectionViewFlowDelegateAlbums {
    
    var flowDelegateHandler: UICollectionViewFlowDelegateHandler!
    
    var artistDetail : ArtistDetail! {
        didSet {
            self.navigationItem.title = artistDetail.heading.name
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib(nibName: "AlbumCell", bundle: Bundle.main), forCellWithReuseIdentifier: "AlbumCell")
            
            var reference = self
            reference.useProtocolForCollectionView(collectionView: collectionView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ArtistAlbumsVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        
        let album = Album(photoUrl: "mock_album", name: "Salad Days", artist: "2014")
        cell.setContent(album)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            let artistCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ArtistInfoHeaderCell", for: indexPath) as! ArtistInfoHeaderCell
        
            artistCell.setContent(artistDetail)
            artistCell.setArtistInfoCallback(artistInfoCallback)
            return artistCell

    }
    
}

extension ArtistAlbumsVC {
    // MARK : Supplementary methods to handle navigation
    
    func artistInfoCallback() {
        let popup = PopupDialog(title: nil, message: artistDetail.description.trim(to: 500))
        
        if let url = artistDetail.lastFmUrl {
            let buttonMore = DefaultButton(title: "See more on LastFm") {
                if #available(iOS 10.0, *) {
                    print(url.absoluteString)
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            
            popup.addButton(buttonMore)
        }
        
        let buttonDismiss = DefaultButton(title: "OK") {}
        popup.addButton(buttonDismiss)
        self.present(popup, animated: true, completion: nil)
    }
}
