//
//  SearchViewController.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 02/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit

class SearchArtistsVC : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var searchController : UISearchController! {
        didSet {
            self.searchController.searchResultsUpdater = self
            self.searchController.delegate = self
            self.searchController.searchBar.delegate = self
            
            self.searchController.hidesNavigationBarDuringPresentation = false
            self.searchController.dimsBackgroundDuringPresentation = false
            
            self.navigationItem.titleView = searchController.searchBar
            
            self.definesPresentationContext = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchController = UISearchController(searchResultsController:  nil)
        
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.searchController.isActive = true
    }
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case "searchToArtistAlbums":
            let destination = segue.destination as! ArtistAlbumsVC
            //let indexPath = tableView.indexPathForSelectedRow!
            //let selectedObject = fetchedResultsController.object(at: indexPath) as! BookingMO
            var tags = [String]()
            tags.append("Lo-Fi")
            tags.append("Indie")
            tags.append("Garage")

            destination.artistDetail = ArtistDetail(Artist(photoUrl: "mock_artist", name: "Mac DeMarco", gender: "Indie"), tags: tags, description: "Mac DeMarco is the antithesis to your stereotypical singer-songwriter. Disregarding the seriously somber moments, he replaces them with whimsical and youthful spontaneity, whilst retaining endearing and subtle commentaries. Promptly after leaving his Edmonton garage for Vancouver he embarked on a grand voyage of enlightenment and alcoholic debauchery.\n\nDeMarco’s a weird cat, cultivating an affinity for occult imagery, nudity and social satire. But <a href=\"https://www.last.fm/music/Mac+DeMarco\">Read more on Last.fm</a>")
        default:
            if let id = segue.identifier {
                print("Unknown segue: \(id)")
            }
        }
    }
}

extension SearchArtistsVC : UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    //MARK : UISearchControllerDelegate
    
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
    
    //MARK : UISearchBarDelegate
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: false, completion: {
            searchBar.resignFirstResponder()
        })
    }
    
    //MARK : UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension SearchArtistsVC : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Recent Searches"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell", for: indexPath) as! ArtistCell
        
        let artist = Artist(photoUrl: "mock_artist", name: "Mac DeMarco", gender: "Indie")
        cell.setContent(artist)
        
        return cell
    }
}
