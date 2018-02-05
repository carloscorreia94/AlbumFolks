//
//  Album.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 03/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import ObjectMapper
import Alamofire

struct _Album {
    let photoUrl, name, artist : String
}

class Album : Mappable, Equatable {
    var photoUrl : URL?
    var name : String!
    var id : String?
    var albumDetail : AlbumDetail?
    var artist : Artist!
    
    /** For ease of network request upon lazy loading of album (details) (while scrolling on the artist page)
     * Easier to compare albums by just having an array of request Album details and making simple comparisons
     **/
    static func ==(lhs:Album, rhs:Album) -> Bool {
        if let lhs_mbid = lhs.id, let rhs_mbid = rhs.id {
            return lhs_mbid == rhs_mbid
        } else {
            /* sometimes the LASTFM api doesn't provide mbids and to check for album detail
            (unambigous content) we need name of the album and name of the artist */
            return lhs.name == rhs.name && lhs.artist.name == rhs.artist.name
        }
    }
    
    required init?(map: Map){
        
        // We're certified of having an associated artist (Inmplicitly unwrapped optional artist variable) upon Album object usage
        
        if let name : String = map["name"].value() {
            //sometimes we have (null) string on the album name
            if name == "(null)" {
                return nil
            }
        } else {
            return nil
        }
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        id <- map["mbid"]
        
        var images : [LastFmImage]?
        images <- map["image"]
        
        if let images = images {
            if !images.isEmpty {
                if let index = images.index(where: { $0.imageSize == .large }) {
                    photoUrl = images[index].url
                } else {
                    photoUrl = images[0].url
                }
            }
        }
        
    }
    
    /**
    * I didn't pass just the string as usual to get the content because Artist reference is of use here for the artist association with the album. Used on the Track Screen (Album Detail) too see which Artist is entiteled to the album
    **/
    static func fetchTopAlbums(artist: Artist, successCallback: @escaping ([Album]) -> (), errorCallback: @escaping (NetworkError) -> ()) {
        
        let URL = String(format: Constants.API_URLS.ArtistAlbums,artist.id)
        
        Alamofire.request(URL).responseArray(keyPath: "topalbums.album") { (response: DataResponse<[Album]>) in
            let (success, error) = CoreNetwork.handleResponse(response)
            
            if let error = error {
                errorCallback(error)
            } else {
                //I couldn't find a better way/place to link back the album with the artist than WMD/here (WMD - with this method)
                
                for album in success! {
                    album.artist = artist
                }
                successCallback(success!)
            }
        }
    }
}
