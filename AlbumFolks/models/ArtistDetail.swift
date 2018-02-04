//
//  ArtistDetail.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 02/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import ObjectMapper
import Alamofire


class Tag : Mappable {
    
    var name : String!
    
    required init?(map: Map){
        guard let _: String = map["name"].value() else {
            return nil
        }
    }
    
    func mapping(map: Map) {
        name <- map["name"]
    }
    
    static func getTagsString(_ tags: [Tag]) -> String? {
        
        if tags.count == 0 {
            return nil
        } else if tags.count == 1 {
            return tags[0].name
        }
        
        var formattedStr = ""
        for i in 0...tags.count-1 {
            formattedStr.append(tags[i].name)
            
            if i < tags.count-1 {
                formattedStr.append(", ")
            }
        }
        
        return formattedStr
        
    }
}

class ArtistDetail : Mappable {
    var tags : [Tag]?
    var description : String!
    var lastFmUrl : URL?
    
    required init?(map: Map){
      
        
        guard let _: String = map["bio.summary"].value() else {
            return nil
        }
        
    }
    
    func mapping(map: Map) {
        description <- map["bio.summary"]
        lastFmUrl = cropDescriptionGetURL()
        tags <- map["tags.tag"]
    }
    
    
    func getTagsString() -> String? {
        if let tags = tags {
            return Tag.getTagsString(tags)
        }
        return nil
    }
    
    private func cropDescriptionGetURL() -> URL? {
        var returnUrl : URL?
       
        let descriptionSplitHrefTag = description.components(separatedBy: "<a href=\"")
        if descriptionSplitHrefTag.count > 1 {
            description = descriptionSplitHrefTag[0]
            
            let linkFromEnclosingTag = descriptionSplitHrefTag[1].components(separatedBy: "\">")
            if linkFromEnclosingTag.count > 1 {
                returnUrl = URL(string: linkFromEnclosingTag[0])
            }
        }
        return returnUrl
    }
    
    static func fetchNetworkData(artistId: String, successCallback: @escaping (ArtistDetail) -> (), errorCallback: @escaping (NetworkError) -> ()) {
        let URL = "https://ws.audioscrobbler.com/2.0/?method=artist.getinfo&mbid=f2492c31-54a8-4347-a1fc-f81f72873bbf&api_key=817be21ebea3ab66566f275369c6c4ad&format=json"
        
        let URL = String(format: "\(CoreNetwork.API_URLS.ArtistDetail)&\(CoreNetwork.COMMON_KEYS.ID)","")
        
        
        Alamofire.request(URL).responseObject(keyPath: "artist") { (response: DataResponse<ArtistDetail>) in
            
            let (success, error) = CoreNetwork.handleResponse(response)
            
            if let error = error {
                errorCallback(error)
            } else {
                successCallback(success)
            }
            
        }
    }
    
}
