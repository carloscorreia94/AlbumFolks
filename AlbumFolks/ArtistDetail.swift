//
//  ArtistDetail.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 02/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

class ArtistDetail {
    let tags : [String]
    let description : String
    let heading : Artist
    
    init(_ heading: Artist,tags: [String], description: String) {
        self.heading = heading
        self.tags = tags
        self.description = description
    }
    
}
