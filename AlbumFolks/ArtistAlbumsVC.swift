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
    var noFetchedAlbums = false
   
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib(nibName: "AlbumCell", bundle: Bundle.main), forCellWithReuseIdentifier: "AlbumCell")
            
            
        }
    }
    
    /**
     * I'm not super sure about this (artist attribution) being called imediately before (just in time) the view is loaded. Still, it's for me the best way to do a request before the view initializes. One could issue a notification from viewDidLoad and make the network callback wait until the notification is triggered. I have to test it with more time :-)
    **/
    var artist : Artist! {
        didSet {
            self.navigationItem.title = artist.name
            
            if artist.detail == nil {
                
                ArtistDetail.fetchNetworkData(artistId: self.artist.id, successCallback: { [unowned self] artistDetail in
                    
                    self.artist.detail = artistDetail
                    self.collectionView.reloadData()
                    
                    self.albumRequest()
                    
                    }, errorCallback: { [unowned self] error in
                        let errorTitleDesc = CoreNetwork.messageFromError(error)
                        
                        AlertDialog.present(title: errorTitleDesc.title, message: errorTitleDesc.desc, vController: self, action: { _ in
                            self.navigationController!.popViewController(animated: true)
                        })
                        
                        
                })
                
            }
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
    
    
    private func albumRequest() {
        
        Album.fetchTopAlbums(artist: self.artist, successCallback: { [unowned self] albums in
            
            //TODO - Check for no receiving albums - we might want to go to the notFetchedAlbums = true
            //returns 16 albums tops
            self.artist.albums = Array(albums.prefix(16))
            self.collectionView.reloadData()
            
            }, errorCallback: { [unowned self] error in
                
                let errorTitleDesc = CoreNetwork.messageFromError(error)
                AlertDialog.present(title: errorTitleDesc.title, message: errorTitleDesc.desc, vController: self, action: { _ in
                    self.noFetchedAlbums = true
                    self.collectionView.reloadData()
                })
                
                
        })
        
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
           
            
          
           // destination.albumDetail = albumDetail
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
        
       
        
        let _album = _Album(photoUrl: "", name: album.name, artist: artist.name)
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
            
            for view in cell.subviews {
                view.removeFromSuperview()
            }
            
            
            /**
            * There's two possible situations for footer being shown. One is the loading process, the other is not having albums (network error or simply no album info)
            **/
            
            if noFetchedAlbums {
                
                let label = UILabel(frame: CGRect(x:0,y: 0,width: 250,height: 25))
                label.textAlignment = .center
                label.textColor = .black
                label.font = UIFont.systemFont(ofSize: 19.0, weight: UIFont.Weight.light)
                label.text = "No Fetched Albums"
                
                cell.addSubview(label)
            } else {
                let loadingView = LoadingIndicatorView.create(centerX: cell.center.x, originY: 8, size: cell.frame.size.height * 0.8)
                cell.addSubview(loadingView)
            }
     
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
