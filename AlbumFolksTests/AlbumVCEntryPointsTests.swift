//
//  AlbumFolksTests.swift
//  AlbumFolksTests
//
//  Created by Carlos Correia on 01/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import CoreData
import XCTest
@testable import AlbumFolks

class AlbumVCEntryPointsTests: XCTestCase {
    
    
    var volatileAlbum : Album?
    var context: NSManagedObjectContext!
    var albumVC: AlbumVC!
    
    
    /**
     * In order to emulate app main functionality (see the stored album information) we need:
    1. A testing database clone - "context with new persistent store"
    2. A mocked album - instead of coming from the API or creating a mock object for network response I injected the JSON data directly from a file
    3. A testing ViewController - added a Storyboard ID to the Album VC for this purpose (it didn't needed it beforehand)
     
     
     Furthermore, the following tests follow the normal user journey on the app (omitting the process of album search and album click) i.e, visualizing an album coming from the API, saving it, and later consulting a saved album.
    **/
    override func setUp() {
        super.setUp()
        
        guard let context = CoreDataHelpers.setUpInMemoryManagedObjectContext() else {
            XCTFail()
            return
        }
        
        self.context = context
        
        volatileAlbum = DeserializeHelpers.getTestAlbumFromJSONFile(testObj: self)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AlbumVCTestEntrance") as! AlbumVC
        albumVC = vc
        
    }
    
    override func tearDown() {
        self.context = nil
        self.albumVC = nil
        super.tearDown()
    }
    
    /**
    * Test that an object with the same serialized structure as if it was coming from the API will be correctly validated and accepted by the instance models (Artist, Album, AlbumDetail)
    **/
    func testLoadVolatileAlbum() {
        XCTAssertNotNil(volatileAlbum)
    }
    
    
    /**
    * Test that the object transformation preserved the required attributes to show on a view
    **/
    func testAlbumViewPopulatorPropertiesFromVolatile() {
        guard let album = volatileAlbum else {
            XCTFail()
            return
        }
        
        let populator = AlbumViewPopulator(album: album)

        guard let detail = volatileAlbum?.albumDetail else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(String(album.hashValue), populator.hashString)
        XCTAssertEqual(album.artist.mbid, populator.artist.mbid)
        XCTAssertEqual(album.name, populator.name)
        XCTAssertEqual(detail.getTagsString(), populator.tags)
        XCTAssertEqual(detail.tracks.count, populator.tracks.count)
    }
    
   
    /**
    * Test that the view actually is showing to the user the same elements from the AlbumViewPopulator
    **/
    func testPopulateVCwithVolatileAlbum() {
        guard let album = volatileAlbum else {
            XCTFail()
            return
        }
        
        let populator = AlbumViewPopulator(album: album)
        albumVC.albumViewPopulator = populator
        _ = albumVC.view
        
        XCTAssertEqual(albumVC.albumInfoHeader.albumArtist.text ?? "", populator.artist.name)
        XCTAssertEqual(albumVC.navigationItem.title ?? "", populator.name)
        XCTAssertEqual(albumVC.tableView.numberOfRows(inSection: 0), populator.tracks.count)

    }
    
    
    /**
     * Test that from our existing volatile data structure (now transformed into a populator to display info to the user) we can successfully persist an Album with all associated model entity objects (ArtistMO, TrackMO's)
     **/
    func testSaveAlbumFromVolatile() {
        guard let album = volatileAlbum else {
            XCTFail()
            return
        }
        
        let populator = AlbumViewPopulator(album: album)
        
        let storedAlbum = AlbumMO.create(from: populator, context: context)
        
        XCTAssertNotNil(storedAlbum)
        XCTAssertNotNil(storedAlbum?.artist)
        XCTAssertNotNil(storedAlbum?.tracks)
    }
    
    /**
     * Test that after visualizing an album, saving it, and later instantiating the Populator required to show the view, we having faithful information
     **/
    func testAlbumViewPopulatorPropertiesFromSaved() {
        guard let album = volatileAlbum else {
            XCTFail()
            return
        }
        
        let populator = AlbumViewPopulator(album: album)
        guard let storedAlbum = AlbumMO.create(from: populator, context: context) else {
            XCTFail()
            return
        }
        
        let populatorFromSaved = AlbumViewPopulator(albumMO: storedAlbum)
        
        
        XCTAssertEqual(storedAlbum.stringHash!, populatorFromSaved.hashString)
        XCTAssertEqual(storedAlbum.artist!.mbid!, populatorFromSaved.artist.mbid)
        XCTAssertEqual(storedAlbum.name!, populatorFromSaved.name)
        XCTAssertEqual(storedAlbum.tags, populatorFromSaved.tags)
        XCTAssertEqual(storedAlbum.tracks?.count ?? 0, populatorFromSaved.tracks.count)
    }
    
    
    /**
    * Last test step . After saving an album we test for it's visible info (in the UI) to be coherent with what comes from the persistent store and even from the volatile object from the first test (as it was comming fresh from the API)
    **/
    func testPopulateVCwithSavedAlbum() {
        guard let album = volatileAlbum else {
            XCTFail()
            return
        }
        
        guard let detail = volatileAlbum?.albumDetail else {
            XCTFail()
            return
        }
        
        let populator = AlbumViewPopulator(album: album)
        
        let storedAlbum = AlbumMO.create(from: populator, context: context)
        XCTAssertNotNil(storedAlbum)

        
        albumVC.albumViewPopulator = AlbumViewPopulator(albumMO: storedAlbum!)
        _ = albumVC.view
        
        XCTAssertEqual(albumVC.albumInfoHeader.albumArtist.text ?? "", populator.artist.name)
        XCTAssertEqual(albumVC.navigationItem.title ?? "", populator.name)
        XCTAssertEqual(albumVC.tableView.numberOfRows(inSection: 0), populator.tracks.count)
        
        XCTAssertEqual(albumVC.albumInfoHeader.albumArtist.text ?? "", album.artist.name)
        XCTAssertEqual(albumVC.navigationItem.title ?? "", album.name)
        XCTAssertEqual(albumVC.tableView.numberOfRows(inSection: 0), detail.tracks.count)
        
        
    }
}
