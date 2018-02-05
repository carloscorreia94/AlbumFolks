//
//  SearchViewController.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 02/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit
import AlamofireImage


/**
 * I didn't subclass UITableViewController as it makes it more flexible to change the layout /incrementally add more components starting with an embedded UITableView in a blank ViewController
 **/
class SearchArtistsVC : UIViewController {
    
    fileprivate let imgDownloader = ImageDownloader()
    static let MIN_SEARCH_QUERY_LENGTH = 4
    static let SEARCH_INTERVAL_TIMER = 0.5
    
    fileprivate var searchTimer: Timer?
    fileprivate var artists : [Artist]?
    fileprivate var paginatedArtists = Dictionary<Pagination,PaginatedArtists>()
    fileprivate var currentPagination : Pagination?
    
    fileprivate var isSearching = false
    fileprivate var recentSearchesMode = true
    
    lazy var loadingView : UIView = {
        let view = UIView(frame: CGRect(origin: CGPoint(x: 0,y:0), size: CGSize(width:self.tableView.frame.size.width, height: 80)))
        let loadingView = LoadingIndicatorView.create(centerX: view.center.x, originY: 15, size: view.frame.size.height * 0.8)
        view.addSubview(loadingView)
        return view
    }()
    
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
            
            let indexPath = tableView.indexPathForSelectedRow!
            guard let artist = self.artists?[indexPath.row] else {
                fatalError("Internal inconsistency upon fetching Artist")
            }
            
            let destination = segue.destination as! ArtistAlbumsVC
            destination.artist = artist
            
            let backItem = UIBarButtonItem()
            backItem.title = "Search"
            navigationItem.backBarButtonItem = backItem
        default:
            if let id = segue.identifier {
                print("Unknown segue: \(id)")
            }
        }
    }
    
    @objc private func performSearchTimer(_ timer : Timer) {
        isSearching = false
        performSearch(timer.userInfo as! String)
    }
    
    private func performSearch(_ query: String) {
        print("searching" + query)
        self.recentSearchesMode = false
        self.tableView.tableHeaderView = loadingView
        self.tableView.reloadData()
        //TODO - Animation

        
        Artist.fetchAutoCompleteSearch(query: query, successCallback: { [unowned self] paginatedArtists in
            
            
            if !self.isSearching {
                self.tableView.tableHeaderView = nil
            }
            
            self.currentPagination = Pagination(limit: paginatedArtists.itemsPerPage, offset: paginatedArtists.start, total: paginatedArtists.total)
            
            self.paginatedArtists[self.currentPagination!] = paginatedArtists
            self.artists = paginatedArtists.artists
            self.tableView.reloadData()
            
        }, errorCallback: { error in
            if !self.isSearching {
                self.tableView.tableHeaderView = nil
            }
            
        })
        
    }
    
    private func showRecentSearches() {
        self.tableView.tableHeaderView = nil
        self.artists = nil
        self.recentSearchesMode = true
        self.tableView.reloadData()
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
    
    /**
    * Logic for searching is -> Whenever user types query multiple of 3 or after stops writing -> Network Call
    **/
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = searchBar.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        /**
        * Conditions fall here if we're deleting past 3 chars or writing less than 3 chars
        **/
        if newText.count < SearchArtistsVC.MIN_SEARCH_QUERY_LENGTH
            || ( newText.count < currentText.count && newText.count < SearchArtistsVC.MIN_SEARCH_QUERY_LENGTH )  {
            //going to the suggestions again and invalidating previous timer callbacks
            searchTimer?.invalidate()
            showRecentSearches()
            return true
        }
        
        isSearching = true
        if newText.count >= SearchArtistsVC.MIN_SEARCH_QUERY_LENGTH && newText.count % 3 == 0 {
            performSearch(newText)
        }
        
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(timeInterval: SearchArtistsVC.SEARCH_INTERVAL_TIMER, target: self, selector: #selector(performSearchTimer), userInfo: newText, repeats: false)
        
        return true
    }
    
    //MARK : UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}

extension SearchArtistsVC : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return self.recentSearchesMode ? "Recent Searches" : nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let artist = self.artists?[indexPath.row] else {
            fatalError("Internal inconsistency upon fetching Artist")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell", for: indexPath) as! ArtistCell
        cell.setContent(artist)
        
        //TODO - Default Photo for Artist
        if let url = artist.photoUrl {
            let urlRequest = URLRequest(url: url)
            imgDownloader.download(urlRequest) { response in
                
                if let image = response.result.value {
                    cell.setImage(image)
                }
            }
        }
        
        
        return cell
    }
}
