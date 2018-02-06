//
//  Artist.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 03/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class Artist : Mappable {
    
    var detail: ArtistDetail?
    var albums : [Album]?
    var requestedAlbumDetails : Dictionary<Album,Bool>?
    
    var photoUrl : URL?
    var lastFmUrl : URL?
    var listeners : Int?
    
    var name : String!
    var id : String!
    
    required init?(map: Map){
        
        // We're certified of having an associated artist (Inmplicitly unwrapped optional artist variable) upon Album object usage
        
        guard let _: String = map["name"].value() else {
            return nil
        }
        
        // We just return Artists if they have mbid associated
        guard let mbid: String = map["mbid"].value(), let _ : Int? = mbid.isEmpty ? nil : 1 else {
            return nil
        }
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        id <- map["mbid"]
        photoUrl = LastFmImage.getImageUrl(imageMap: map,imageKey: "image")
        
        var urlString : String?
        urlString <- map["url"]
        
        if let urlString = urlString, let url = URL(string: urlString) {
            self.lastFmUrl = url
        }
        
        var listenersString : String?
        listenersString <- map["listeners"]
        
        if let listenersString = listenersString, let listeners = Int(listenersString) {
            self.listeners = listeners
        }
        
    }
    
    static func fetchAutoCompleteSearch(query: String, successCallback: @escaping (PaginatedArtists) -> (), errorCallback: @escaping (NetworkError) -> ()) {
        
        if let url = String(format: Constants.API_URLS.ArtistAutoCompleteSearch,query).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            Alamofire.request(url).responseObject(keyPath: "results") { (response: DataResponse<PaginatedArtists>) in
                let (success, error) = CoreNetwork.handleResponse(response)
                
                if let error = error {
                    errorCallback(error)
                } else {
                    successCallback(success!)
                }
            }
        } else {
            errorCallback(.WrongContent)
        }
        
       
    }

}
