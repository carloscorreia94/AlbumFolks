//
//  PaginatedResult.swift
//  AlbumFolks
//
//  Created by NTW-laptop on 05/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import Foundation
import ObjectMapper

struct Pagination {
    let startIndex, page, total : Int
}

extension Pagination : Hashable, Equatable {
    
    static func ==(lhs:Pagination, rhs:Pagination) -> Bool {
        return lhs.startIndex == rhs.startIndex && lhs.page == rhs.page && rhs.total == lhs.total
    }
    
    var hashValue: Int {
        return total.hashValue ^ page.hashValue
    }
}

class PaginatedArtists : Mappable {
    var total: Int!
    var page: Int!
    var limit: Int!
    var startIndex : Int!
    var artists: [Artist]!
    
    
    required init?(map: Map){
        guard let total: String = map["opensearch:totalResults"].value(), let _ : Int = Int(total) else {
            return nil
        }
        
        guard let page: String = map["opensearch:Query.startPage"].value(), let _ : Int = Int(page) else {
            return nil
        }
        
        guard let limit: String = map["opensearch:itemsPerPage"].value(), let _ : Int = Int(limit) else {
            return nil
        }
        
        guard let startIndex: String = map["opensearch:startIndex"].value(), let _ : Int = Int(startIndex) else {
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
        startIndex = Int(stringStart)!
        
        var stringItemsPerPage : String!
        stringItemsPerPage <- map["opensearch:itemsPerPage"]
        limit = Int(stringItemsPerPage)!
        
        var stringPage : String!
        stringPage <- map["opensearch:Query.startPage"]
        page = Int(stringItemsPerPage)!
        
    
        artists <- map["artistmatches.artist"]
    }
}
