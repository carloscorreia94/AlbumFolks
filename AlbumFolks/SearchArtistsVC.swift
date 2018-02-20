//
//  SearchViewController.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 02/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit
import AlamofireImage
import CoreData

/**
 * I didn't subclass UITableViewController as it makes it more flexible to change the layout /incrementally add more components starting with an embedded UITableView in a blank ViewController
 **/
class SearchArtistsVC : UIViewController {
    
    static let MAX_RECENT_SEARCH_ENTRIES = 10
    static let MIN_SEARCH_QUERY_LENGTH = 2
    static let MAX_SEARCH_RESULTS = 12
    static let MAX_PAGE_NUMBER = 50
    static let PAGE_DECREMENT_FACTOR_PER_EXTRA_CHAR = 2
    
    static let SEARCH_INTERVAL_TIMER = 0.5
    static let DEFAULT_PAGINATION = Pagination(startIndex: 0, page: 1, total: SearchArtistsVC.MAX_SEARCH_RESULTS)
    
    fileprivate var searchTimer: Timer?
    fileprivate var artists : [Artist]?
    fileprivate var paginatedArtists = Dictionary<Pagination,PaginatedArtists>()
    fileprivate var currentPagination : Pagination?
    fileprivate var askedPagination = DEFAULT_PAGINATION
    fileprivate var isSearching = false
    fileprivate var isFetching = false
    fileprivate var recentSearchesMode = true
    
    fileprivate var context : NSManagedObjectContext?
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        context = (UIApplication.shared.delegate as! AppDelegate).persistenceController.managedObjectContext
        
        let searchFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RecentSearch")
        let primarySortDescriptor = NSSortDescriptor(key: "time", ascending: false)
        searchFetchRequest.sortDescriptors = [primarySortDescriptor]
        searchFetchRequest.fetchLimit = SearchArtistsVC.MAX_RECENT_SEARCH_ENTRIES
        
        let frc = NSFetchedResultsController(
            fetchRequest: searchFetchRequest,
            managedObjectContext: context!,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return frc
    }()
    
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
        showRecentSearches()
        
        let notificationCenter = NotificationCenter.default

        notificationCenter.addObserver(self, selector: #selector(contextDidSave), name: .NSManagedObjectContextDidSave, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.searchController.isActive = true
        //workout to force searchbar appear as the keyboard
        GenericHelpers.mainQueueDelay(0.1) { self.searchController.searchBar.becomeFirstResponder() }

    }
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case "searchToArtistAlbums":
            
            
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)!
            let destination = segue.destination as! ArtistAlbumsVC

            if recentSearchesMode {
                let recentSearch = fetchedResultsController.object(at: indexPath) as! RecentSearchMO
                let artist = Artist(from: recentSearch.artist!)
                
                destination.artist = artist
            } else {
                guard let artist = self.artists?[indexPath.row] else {
                    fatalError("Internal inconsistency upon fetching Artist")
                }
            
                destination.artist = artist
            }
            
            let backItem = UIBarButtonItem()
            backItem.title = "Search"
            navigationItem.backBarButtonItem = backItem
        default:
            if let id = segue.identifier {
                print("Unknown segue: \(id)")
            }
        }
    }
    
   
    
    private func performSearch(_ query: String? = nil) {
        print("searching \(query ?? searchController.searchBar.text!) page: \(self.askedPagination.page) ")
        self.recentSearchesMode = false
        self.tableView.tableHeaderView = loadingView
        self.tableView.reloadData()

        
        if query != nil {
            self.paginatedArtists = Dictionary<Pagination, PaginatedArtists>()
            self.artists = nil
            self.askedPagination = SearchArtistsVC.DEFAULT_PAGINATION
            self.currentPagination = nil
        } else {
            self.tableView.tableHeaderView = nil
        }
        
        self.tableView.reloadData()

        
        Artist.fetchAutoCompleteSearch(query: query ?? searchController.searchBar.text!, pagination: self.askedPagination, successCallback: { [unowned self] paginatedArtists in
            
            if !self.isSearching {
                self.tableView.tableHeaderView = nil
            }
            
            self.currentPagination = Pagination(startIndex: paginatedArtists.startIndex, page: paginatedArtists.page, total: paginatedArtists.total)
            
            self.paginatedArtists[self.currentPagination!] = paginatedArtists
            //TODO - Memory recycle artists variable (when you have tons of results, what to do?)
            
            if self.artists == nil {
                self.artists = [Artist]()
            }
            
            self.artists?.append(contentsOf: self.paginatedArtists[self.currentPagination!]!.artists)
           
            self.tableView.reloadData()
            self.isFetching = false
            
            self.tableView.finishInfiniteScroll()
            
        }, errorCallback: { error in
            self.isFetching = false
            self.tableView.finishInfiniteScroll()


            if !self.isSearching {
                self.tableView.tableHeaderView = nil
            }
            
            let errorTitleDesc = CoreNetwork.messageFromError(error)
            AlertDialog.present(title: errorTitleDesc.title, message: errorTitleDesc.desc, vController: self)
            
        })
        
        self.isFetching = true
    }
    
    private func showRecentSearches() {
        self.tableView.tableHeaderView = nil
        self.artists = nil
        self.recentSearchesMode = true
        
            do {
                try fetchedResultsController.performFetch()
                self.tableView.reloadData()
            } catch {
                print("An error occurred")
            }
    }
    
}

extension SearchArtistsVC : UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    //MARK : UISearchControllerDelegate
    
    func didPresentSearchController(_ searchController: UISearchController) {
        //Nothing for now
    }
    
    //MARK : UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //enter first suggestion
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0 , section: 0)) {
            searchTimer?.invalidate()
            self.performSegue(withIdentifier: "searchToArtistAlbums", sender: cell)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: false, completion: {
            searchBar.resignFirstResponder()
        })
    }
    
    /**
    * Logic for searching is -> Whenever user types query multiple of 3 or after stops writing -> Network Call
    **/
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        /**
         * In case the user has pressed the Search Button - Workaround - this method is called before searchBarSearchButtonClicked(_ :UISearchBar)
        */
        if text == "\n" {
            return true
        }
        
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
        if newText.count >= SearchArtistsVC.MIN_SEARCH_QUERY_LENGTH && newText.count % 3 == 0 && !isFetching {
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
        if recentSearchesMode {
            if let sections = fetchedResultsController.sections {
                let currentSection = sections[0]
                return currentSection.numberOfObjects
            } else {
                return 0
            }
        } else {
            return artists?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistCell", for: indexPath) as! ArtistCell
        var photoUrl : URL?
        
        if recentSearchesMode {
            let recentSearch = fetchedResultsController.object(at: indexPath) as! RecentSearchMO
            cell.setContent(search: recentSearch)
            photoUrl = recentSearch.artist!.getPhotoUrl()
            
        } else {
            guard let artist = self.artists?[indexPath.row] else {
                fatalError("Internal inconsistency upon fetching Artist")
            }
            cell.setContent(artist: artist)
            photoUrl = artist.photoUrl
        }
        
        
        if let url = photoUrl {
            cell.setImage(url)
        }
        
        
        return cell
    }
    
}

extension SearchArtistsVC {
    
    // MARK - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.canScrollDown() {
            if isSearching || isFetching {
                return
            }
            
            if let askedPagination = getNewPagination() {
                
                //invalidate pending autocomplete searches
                searchTimer?.invalidate()
               
                    
                self.askedPagination = askedPagination
                    
                self.tableView.beginInfiniteScroll(true)
                self.isFetching = true
                performSearch()
            }

        }
    }
    
    
    func getNewPagination() -> Pagination? {
        // Means we already searched for something with success
        if let pagination = currentPagination, let searchBarText = searchController.searchBar.text {
        
            let decrementNumber = (SearchArtistsVC.PAGE_DECREMENT_FACTOR_PER_EXTRA_CHAR * (searchBarText.count - SearchArtistsVC.MIN_SEARCH_QUERY_LENGTH))
            if (pagination.page + decrementNumber + 1 < SearchArtistsVC.MAX_PAGE_NUMBER) && (pagination.startIndex + SearchArtistsVC.MAX_SEARCH_RESULTS < pagination.total)  {
                let askedPagination = Pagination(startIndex: 0, page: pagination.page + 1, total: pagination.total)
            
                //If we already have this pagination in memory
                if self.paginatedArtists[askedPagination] != nil {
                    return nil
                }
            
                return askedPagination
            
            }
        }
        return nil
    }
}

extension SearchArtistsVC {
    @objc private func performSearchTimer(_ timer : Timer) {
        isSearching = false
        
        if !isFetching {
            performSearch(timer.userInfo as? String)
        }
    }
    
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset
    }
    
    @objc func contextDidSave(notification: Notification) {
        
        if let context = context, let sender = notification.object as? NSManagedObjectContext {
            if sender != context {
                context.mergeChanges(fromContextDidSave: notification)
                
                if recentSearchesMode {
                    showRecentSearches()
                }
            }
        }
    }
}
