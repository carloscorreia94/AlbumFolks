//
//  ViewController.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 01/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit
import CoreData
import AlamofireImage

class StoredAlbumsVC: UIViewController {
    
    fileprivate var context : NSManagedObjectContext?

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        context = (UIApplication.shared.delegate as! AppDelegate).persistenceController.managedObjectContext
        
        let albumsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
        let primarySortDescriptor = NSSortDescriptor(key: "storedDate", ascending: false)
        albumsFetchRequest.sortDescriptors = [primarySortDescriptor]
        
        let frc = NSFetchedResultsController(
            fetchRequest: albumsFetchRequest,
            managedObjectContext: context!,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return frc
    }()
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib(nibName: "AlbumCell", bundle: Bundle.main), forCellWithReuseIdentifier: "AlbumCell")
        
           
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        do {
            try fetchedResultsController.performFetch()
            self.collectionView.reloadData()
        } catch {
            print("An error occurred")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSave), name: .NSManagedObjectContextDidSave, object: nil)

        
        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
    }
    
    @objc func contextDidSave(notification: Notification) {
        
        
        if let context = context, let sender = notification.object as? NSManagedObjectContext {
            if sender != context {
                context.mergeChanges(fromContextDidSave: notification)
            }
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
            let indexPath = collectionView.indexPathsForSelectedItems![0]
            
            let albumMO = fetchedResultsController.object(at: IndexPath(row: indexPath.row - 1, section: 0)) as! AlbumMO
            let image = albumMO.getLocalImagePathString() != nil ? UIImage(contentsOfFile: albumMO.getLocalImagePathString()!) : nil
            destination.albumViewPopulator = AlbumViewPopulator(albumMO: albumMO, image: image)
            
        default:
            if let id = segue.identifier {
                print("Unknown segue: \(id)")
            }
        }
    }
    
    
}



extension StoredAlbumsVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell

        if indexPath.row == 0 {
            cell.setSearchCellContent()
        } else {
            let albumMO = fetchedResultsController.object(at: IndexPath(row: indexPath.row - 1, section: 0)) as! AlbumMO
            
            cell.setContent(albumMO)
            
            //TODO - Use some caching mechanism here
            if let imageURL = albumMO.getLocalImageURL(), let image = UIImage(contentsOfFile: imageURL.path) {
                cell.setImage(image)
            }
            
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[0]
            return currentSection.numberOfObjects + 1
        } else {
            return 1
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "MyAlbumsHeaderCell", for: indexPath)
    }
    
}

extension StoredAlbumsVC : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK : UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: indexPath.row == 0 ? "searchSegue" : "presentAlbumFromHome", sender: nil)
    }
    
        
    // MARK : UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //TODO - Centralize these
        let cellWidth = collectionView.bounds.width / 2.0
        let cellHeight = cellWidth * (20/15) // ratio as explicitly defined in the AlbumView Layout
        
        return CGSize(width: cellWidth - 8, height: cellHeight)
    }
}

