//
//  AlbumsViewController.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 02/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit
import PopupDialog
import Alamofire
import AlamofireObjectMapper

class ArtistAlbumsVC : UIViewController, UICollectionViewFlowDelegateAlbums {
    
    var flowDelegateHandler: UICollectionViewFlowDelegateHandler!
    
    var artist : Artist! {
        didSet {
            self.navigationItem.title = artist.name
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
        
        //TODO : Change... maybe before view load we can make network call...
        
        
        if artist.detail == nil {
            let URL = "https://ws.audioscrobbler.com/2.0/?method=artist.getinfo&mbid=f2492c31-54a8-4347-a1fc-f81f72873bbf&api_key=817be21ebea3ab66566f275369c6c4ad&format=json"
            Alamofire.request(URL).responseObject(keyPath: "artist") { [unowned self] (response: DataResponse<ArtistDetail>) in
                
                let weatherResponse = response.result.value
                
                if let artistDetail = weatherResponse {
                    self.artist.detail = artistDetail
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case "presentAlbumFromArtist":
            let backItem = UIBarButtonItem()
            backItem.title = "Artist"
            navigationItem.backBarButtonItem = backItem
            
            let destination = segue.destination as! AlbumVC
            //let indexPath = tableView.indexPathForSelectedRow!
            let album = Album(photoUrl: "mock_album", name: "Salad Days", artist: "Mac DeMarco")
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

extension ArtistAlbumsVC {
    @objc func cellTapped(sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "presentAlbumFromArtist", sender: sender)
    }
}

extension ArtistAlbumsVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        
        let tapCell = UITapGestureRecognizer(target: self, action: #selector(cellTapped))
        cell.addGestureRecognizer(tapCell)
        
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
            artistCell.setContent(artist)
        
            if let detail = artist.detail {
                artistCell.setDetailContent(detail)
            }
        
            artistCell.setArtistInfoCallback(artistInfoCallback)
            return artistCell

    }
    
}

extension ArtistAlbumsVC {
    // MARK : Supplementary methods to handle navigation
    
    
    /**
    Concerning the reusableCell LifeCycle and because it's easier to load things at once from a method invocation, I prefered to keep a callback reference on there (ArtistInfoHeaderCell) rather that having another reference to the ArtistDetail, and maybe to the viewController
    **/
    func artistInfoCallback() {
        if let detail = artist.detail {
            let popup = PopupDialog(title: nil, message: detail.description.trim(to: 500))
            
            if let url = detail.lastFmUrl {
                let buttonMore = DefaultButton(title: "See more on LastFm") {
                    if #available(iOS 10.0, *) {
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
}
