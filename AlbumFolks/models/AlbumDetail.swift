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
    
}
