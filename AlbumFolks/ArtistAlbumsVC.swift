//
//  AlbumsViewController.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 02/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit

class ArtistAlbumsVC : UIViewController, UICollectionViewFlowDelegateAlbums {
    
    var flowDelegateHandler: CollectionViewProtocolHandler!
    var artistDetail : ArtistDetail! {
        didSet {
            // TODO - Think on better solution...
            //collectionView.reloadData()
            
            self.navigationItem.title = artistDetail.name
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
            return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ArtistInfoHeaderCell", for: indexPath)

    }
    
}
