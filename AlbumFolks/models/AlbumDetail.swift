//
//  AlbumDetail.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 02/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import ObjectMapper
import Alamofire



class AlbumDetail : Mappable {
    
    var year : String?
    var tracks : [Track]!
    
    required init?(map: Map){
        
        //TODO - Check for track array being empty/nul? Object mapper takes care of this?
        //should be done with guard instead to check for array type?
        if !map["tracks.track"].isKeyPresent {
            return nil
        }
    }
    
    
    func mapping(map: Map) {
        
        var tags : [Tag]?
        tags <- map["tags.tag"]
        
        if let tagsArray = tags {
            if tagsArray.count > 0 {
                year = tagsArray[0].name
            }
        }
        
        tracks <- map["tracks.track"]
    }
    
    /**
    * Album is passed instead of just AlbumID as some albums coming from the API don't have associated ID's and can only be fetched (Detail)
    * resourcing to album name / artist name
    **/
    static func fetchNetworkData(album: Album, successCallback: @escaping (AlbumDetail) -> (), errorCallback: @escaping (NetworkError) -> ()) {
        
        var url : String!
        if let mbid = album.id {
            url = String(format: Constants.API_URLS.AlbumDetailById,mbid)
        } else {
            url = String(format: Constants.API_URLS.AlbumDetailByNameAndArtist,album.name,album.artist.name).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        }
        
        print("Request Album detail with URL: " + url)
        
        Alamofire.request(url).responseObject(keyPath: "album") { (response: DataResponse<AlbumDetail>) in
            let (success, error) = CoreNetwork.handleResponse(response)
             
            if let error = error {
                errorCallback(error)
            } else {
                successCallback(success!)
            }
        }
    }
    
}
