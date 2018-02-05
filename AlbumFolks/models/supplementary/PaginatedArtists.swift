//
//  PaginatedResult.swift
//  AlbumFolks
//
//  Created by NTW-laptop on 05/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import Foundation
import ObjectMapper

class PaginatedArtists : Mappable {
    var total: Int!
    var start: Int!
    var itemsPerPage: Int!
    var artists: [Artist]!
    
    
    required init?(map: Map){
        guard let total: String = map["opensearch:totalResults"].value(), let _ : Int = Int(total) else {
            return nil
        }
        
        guard let start: String = map["opensearch:startIndex"].value(), let _ : Int = Int(start) else {
            return nil
        }
        
        guard let itemsPerPage: String = map["opensearch:itemsPerPage"].value(), let _ : Int = Int(itemsPerPage) else {
            return nil
        }
        
        if !map["artistmatches.artist"].isKeyPresent {
            return nil
        }
    }
    
    func mapping(map: Map) {
        
        var stringTotal : String!
        stringTotal <- map["opensearch:totalResults"]
        total = Int(stringTotal)!
        
        var stringStart : String!
        stringStart <- map["opensearch:startIndex"]
        start = Int(stringStart)!
        
        var stringItemsPerPage : String!
        stringItemsPerPage <- map["opensearch:itemsPerPage"]
        itemsPerPage = Int(stringItemsPerPage)!
        
    
        artists <- map["artistmatches.artist"]
    }
}
