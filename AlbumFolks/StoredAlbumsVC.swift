//
//  ViewController.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 01/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit

class StoredAlbumsVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib(nibName: "AlbumCell", bundle: Bundle.main), forCellWithReuseIdentifier: "AlbumCell")
        
           
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case "presentAlbumFromHome":
            let backItem = UIBarButtonItem()
            backItem.title = self.navigationItem.title
            navigationItem.backBarButtonItem = backItem
            
            let destination = segue.destination as! AlbumVC
            //let indexPath = tableView.indexPathForSelectedRow!
            let album = _Album(photoUrl: "mock_album", name: "Salad Days", artist: "Mac DeMarco")
            let artist = Artist(photoUrl: "mock_artist", name: "Mac DeMarco", gender: "Indie")
            var tracks = [Track]()
            tracks.append(Track(id: 1, duration: "3:00", name: "Salad Days"))
            tracks.append(Track(id: 2, duration: "2:20", name: "Blue Boy"))
            tracks.append(Track(id: 3, duration: "4:01", name: "Brother"))
            tracks.append(Track(id: 4, duration: "3:00", name: "Salad Days"))
            tracks.append(Track(id: 5, duration: "3:00", name: "Salad Days"))
            tracks.append(Track(id: 1, duration: "3:00", name: "Salad Days"))
            tracks.append(Track(id: 2, duration: "2:20", name: "Blue Boy"))
            tracks.append(Track(id: 3, duration: "4:01", name: "Brother"))
            tracks.append(Track(id: 4, duration: "3:00", name: "Salad Days"))
            tracks.append(Track(id: 5, duration: "3:00", name: "Salad Days"))
            tracks.append(Track(id: 1, duration: "3:00", name: "Salad Days"))
            tracks.append(Track(id: 2, duration: "2:20", name: "Blue Boy"))
            tracks.append(Track(id: 3, duration: "4:01", name: "Brother"))
            tracks.append(Track(id: 4, duration: "3:00", name: "Salad Days"))
            tracks.append(Track(id: 5, duration: "3:00", name: "Salad Days"))

            let albumDetail = AlbumDetail(artist: artist, album: album, year: "2014", tracks: tracks)
            destination.albumDetail = albumDetail
            
        default:
            if let id = segue.identifier {
                print("Unknown segue: \(id)")
            }
        }
    }
}

extension StoredAlbumsVC {
    @objc func cellTapped(sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "presentAlbumFromHome", sender: sender)
    }
}


extension StoredAlbumsVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        
        let tapCell = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        cell.addGestureRecognizer(tapCell)
        
        let album = _Album(photoUrl: "mock_album", name: "Salad Days", artist: "Mac DeMarco")
        cell.setContent(album)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "MyAlbumsHeaderCell", for: indexPath)
        } else {
            return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "MyAlbumsFooterCell", for: indexPath)
        }
    }
    
}

extension StoredAlbumsVC : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        
    // UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //TODO - Centralize these
        let cellWidth = collectionView.bounds.width / 2.0
        let cellHeight = cellWidth * (17/15) // ratio as explicitly defined in the AlbumView Layout
        
        return CGSize(width: cellWidth - 8, height: cellHeight)
    }
}

