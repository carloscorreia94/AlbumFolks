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

class Album : Mappable, Equatable, Hashable {
    var photoUrl : URL?
    var name : String!
    var id : String?
    var albumDetail : AlbumDetail?
    var artist : Artist!
    
    /** For ease of network request upon lazy loading of album (details) (while scrolling on the artist page)
     * I keep a hashmap / dictionary with albums as keys and bools as values
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
    
    var hashValue: Int {
        
        if let mbid = id {
            return mbid.hashValue ^ name.hashValue
        } else {
            return name.hashValue ^ artist.name.hashValue
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
        photoUrl = LastFmImage.getImageUrl(imageMap: map,imageKey: "image")
        
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
