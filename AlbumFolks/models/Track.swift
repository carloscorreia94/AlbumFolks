//
//  Track.swift
//  AlbumFolks
//
//  Created by NTW-laptop on 04/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import ObjectMapper
import Alamofire

class Track : Mappable {
    
    var number: Int!
    var title: String!
   // var length: Date!
    
    required init?(map: Map){
        
        guard let _: String = map["name"].value() else {
            return nil
        }
        
        guard let rank: String = map["@attr.rank"].value(), let _ : Int = Int(rank) else {
            return nil
        }
    }
    
    
    func mapping(map: Map) {
        let rank : String = map["@attr.rank"].value()!
        number = Int(rank)!
        title <- map["name"]
    }
}
