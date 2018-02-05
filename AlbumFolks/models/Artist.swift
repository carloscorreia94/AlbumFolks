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
    //TODO - Last FM Url here - instead from artist detail description
    var lastFmUrl : URL!
    
    var name : String!
    var id : String!
    
    required init?(map: Map){
        
        // We're certified of having an associated artist (Inmplicitly unwrapped optional artist variable) upon Album object usage
        
        guard let _: String = map["name"].value() else {
            return nil
        }
        
        guard let _: String = map["mbid"].value() else {
            return nil
        }
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        id <- map["mbid"]
        photoUrl = LastFmImage.getImageUrl(imageMap: map,imageKey: "image")
        
    }
    
    static func fetchAutoCompleteSearch(query: String, successCallback: @escaping ([Artist]) -> (), errorCallback: @escaping (NetworkError) -> ()) {
        
        if let url = String(format: Constants.API_URLS.ArtistAutoCompleteSearch,query).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            Alamofire.request(url).responseArray(keyPath: "artistmatches.artist") { (response: DataResponse<[Artist]>) in
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
