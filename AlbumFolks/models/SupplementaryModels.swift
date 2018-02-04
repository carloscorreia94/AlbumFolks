//
//  SupplementaryModels.swift
//  AlbumFolks
//
//  Created by NTW-laptop on 04/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import ObjectMapper

enum ImageSize: String {
    case small = "small"
    case medium = "medium"
    case large = "large"
    //no need for extra large
}

class LastFmImage : Mappable {
    var url : URL!
    var imageSize: ImageSize!
    
    required init?(map: Map){
        
        guard let imageSizeString : String = map["size"].value(), let _ = ImageSize(rawValue: imageSizeString) else {
            return nil
        }
        
        guard let urlString : String = map["#text"].value(), let _ = URL(string: urlString) else {
            return nil
        }
        
    }
    
    func mapping(map: Map) {
        // I'm certified that the elements are assigned and validated within it's appropriate types from the logic within init
        var urlString : String!
        urlString <- map["#text"]
        
        url = URL(string: urlString)!
        
        var imageSizeString : String!
        imageSizeString <- map["size"]
        
        imageSize = ImageSize(rawValue: imageSizeString)!
    }
}

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
