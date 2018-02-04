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
import AlamofireImage

class ArtistAlbumsVC : UIViewController {
    
    fileprivate let downloader = ImageDownloader()
        
    var artist : Artist! {
        didSet {
            self.navigationItem.title = artist.name
        }
    }
    
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
        
        //TODO : Change... maybe before view load we can make network call...
        
        
        if artist.detail == nil {
            let URL = "https://ws.audioscrobbler.com/2.0/?method=artist.getinfo&mbid=f2492c31-54a8-4347-a1fc-f81f72873bbf&api_key=817be21ebea3ab66566f275369c6c4ad&format=json"
            
            
            Alamofire.request(URL).responseObject(keyPath: "artist") { [unowned self] (response: DataResponse<ArtistDetail>) in
                
                let weatherResponse = response.result.value
                
                if let artistDetail = weatherResponse {
                    self.artist.detail = artistDetail
                    self.collectionView.reloadData()
                
                    self.albumRequest()
                
                }
            }
        }
    }
    
    
    private func albumRequest() {
        let URL = "https://ws.audioscrobbler.com/2.0/?method=artist.getTopAlbums&mbid=f2492c31-54a8-4347-a1fc-f81f72873bbf&api_key=817be21ebea3ab66566f275369c6c4ad&format=json"
        
        
        Alamofire.request(URL).responseArray(keyPath: "topalbums.album") { [unowned self] (response: DataResponse<[Album]>) in
            
            let weatherResponse = response.result.value
            
            if let albums = weatherResponse {
                //returns 10 albums tops
                self.artist.albums = Array(albums.prefix(11))
                self.collectionView.reloadData()
                
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



extension ArtistAlbumsVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell

        
        guard let album = artist.albums?[indexPath.row] else {
            fatalError("Invalid application state while fetching albums.")
        }
        
        if let albumImageUrl = album.photoUrl {
            let urlRequest = URLRequest(url: albumImageUrl)
            
            downloader.download(urlRequest) { response in
                
                
                if let image = response.result.value {
                    cell.setImage(image)
                }
            }
        }
        
       
        
        let _album = _Album(photoUrl: "mock_album", name: album.name, artist: artist.name)
        cell.setContent(_album)
        
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artist.albums?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let artistCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ArtistInfoHeaderCell", for: indexPath) as! ArtistInfoHeaderCell
            artistCell.setContent(artist)
            
            if let detail = artist.detail {
                artistCell.setDetailContent(detail)
            } else {
                artistCell.setActivityIndicatorView()
            }
            
            artistCell.setArtistInfoCallback(artistInfoCallback)
            return artistCell
        } else {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "LoadingAlbumsFooterCell", for: indexPath)
            
            let loadingView = LoadingIndicatorView.create(centerX: cell.center.x, originY: 8, size: cell.frame.size.height * 0.8)
            cell.addSubview(loadingView)
            
            return cell
        }
        
    }
    
}

extension ArtistAlbumsVC : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK : UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "presentAlbumFromArtist", sender: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 80, height: artist.albums != nil ? 0 : 80)
    }
    
    
    // MARK : UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width / 2.0
        let cellHeight = cellWidth * (17/15) // ratio as explicitly defined in the AlbumView Layout
        
        return CGSize(width: cellWidth - 8, height: cellHeight)
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
