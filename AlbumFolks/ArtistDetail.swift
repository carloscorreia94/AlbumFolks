//
//  ArtistDetail.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 02/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import Foundation

class ArtistDetail {
    let tags : [String]
    var description : String
    let heading : Artist
    var lastFmUrl : URL?
    
    init(_ heading: Artist,tags: [String], description: String) {
        self.heading = heading
        self.tags = tags
        self.description = description
        
        if let url = cropDescriptionGetURL() {
            self.lastFmUrl = url
        }
        
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
    
}
