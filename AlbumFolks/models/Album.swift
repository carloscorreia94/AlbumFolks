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
    var photoUrl : URL?
    var name : String!
    var id : String!
    
    required init?(map: Map){
        
        
        guard let _: String = map["name"].value(), let _: String = map["mbid"].value() else {
         return nil
         }
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        id <- map["mbid"]
        
        var images : [LastFmImage]?
        images <- map["image"]
        
        if let images = images {
            if let index = images.index(where: { $0.imageSize == .large }) {
                photoUrl = images[index].url
            } else {
                photoUrl = images[0].url
            }
        }
        
    }
}
