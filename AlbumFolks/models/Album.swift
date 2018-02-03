//
//  Album.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 03/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import ObjectMapper

struct _Album {
    let photoUrl, name, artist : String
}

class Album : Mappable {
    var photoUrl : String? //Several photos for different devices?
    var name : String!
    var id : String!
    
    required init?(map: Map){
        
        
        /*     guard let _: String = map["bio.summary"].value() else {
         return nil
         } */
        
    }
    
    func mapping(map: Map) {
        //    description <- map["bio.summary"]
        //   lastFmUrl = cropDescriptionGetURL()
        //   tags <- map["tags.tag"]
    }
}
