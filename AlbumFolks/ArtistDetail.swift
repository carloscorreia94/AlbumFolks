//
//  ArtistDetail.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 02/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import ObjectMapper

class ArtistDetail : Mappable {
    var tags : [String]!
    var description : String!
    var lastFmUrl : URL?
    
    required init?(map: Map){
      
        
        guard let _: String = map["bio.summary"].value() else {
            return nil
        }
        
    }
    
    func mapping(map: Map) {
        //tags <- map["tags"]
        description <- map["bio.summary"]
        
        
    }
    
  /*  init(_ heading: Artist,tags: [String], description: String) {
        self.heading = heading
        self.tags = tags
        self.description = description
        
        if let url = cropDescriptionGetURL() {
            self.lastFmUrl = url
        }
        
    } */
    
    private func cropDescriptionGetURL() -> URL? {
        /*var returnUrl : URL?
       
        let descriptionSplitHrefTag = description.components(separatedBy: "<a href=\"")
        if descriptionSplitHrefTag.count > 1 {
            description = descriptionSplitHrefTag[0]
            
            let linkFromEnclosingTag = descriptionSplitHrefTag[1].components(separatedBy: "\">")
            if linkFromEnclosingTag.count > 1 {
                returnUrl = URL(string: linkFromEnclosingTag[0])
            }
        }
        return returnUrl */
        return nil
    }
    
}
