//
//  DeserializeHelpers.swift
//  AlbumFolksTests
//
//  Created by NTW-laptop on 18/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import Foundation
import ObjectMapper
@testable import AlbumFolks

class DeserializeHelpers {
    public static func getTestAlbumFromJSONFile(testObj : NSObject) -> Album? {
        if let jsonString = DeserializeHelpers.loadDataString(testObj, name: "testArtistAlbums", ofType: "json") {
            
            if let arr: Array<Album> = Mapper<Album>().mapArray(JSONString: jsonString) {
                if arr.count > 0 {
                
                    let album = arr[0]
                    guard let detail = DeserializeHelpers.getTestAlbumDetailFromJSONFile(testObj: testObj) else {
                        return nil
                    }
                    
                    guard let artist = DeserializeHelpers.getTestArtistFromJSONFile(testObj: testObj) else {
                        return nil
                    }
                    
                    
                    album.albumDetail = detail
                    album.artist = artist
                    return album
                }
            }
        }
        return nil
    }
    
    
    private static func getTestAlbumDetailFromJSONFile(testObj: NSObject) -> AlbumDetail? {
        if let jsonString = DeserializeHelpers.loadDataString(testObj, name: "testAlbumDetail", ofType: "json") {
            
            if let detail : AlbumDetail = Mapper<AlbumDetail>().map(JSONString: jsonString) {
                return detail
            }
        }
        return nil
    }
    
    private static func getTestArtistFromJSONFile(testObj: NSObject) -> Artist? {
        if let jsonString = DeserializeHelpers.loadDataString(testObj, name: "testArtistHeading", ofType: "json") {
            
            if let detail : Artist = Mapper<Artist>().map(JSONString: jsonString) {
                return detail
            }
        }
        return nil
    }
    
    private static func loadDataString(_ obj: NSObject, name : String, ofType: String) -> String? {
        let testBundle = Bundle(for: type(of: obj.self))

        if let filepath = testBundle.path(forResource: name, ofType: ofType) {
            do {
                let contents = try String(contentsOfFile: filepath)
                return contents
            } catch {
                
            }
        }
        
        print("Error loading file with name \(name).\(ofType) from Main Bundle")
        return nil
        
    }
}
