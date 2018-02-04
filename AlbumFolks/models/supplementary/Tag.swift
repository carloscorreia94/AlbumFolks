//
//  Tag.swift
//  AlbumFolks
//
//  Created by NTW-laptop on 04/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//


import ObjectMapper

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
