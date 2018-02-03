//
//  AlbumDetail.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 02/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import Foundation


struct Track {
    let id: Int
    let duration: String
    let name: String
}

class AlbumDetail {
    let artist : Artist
    let album : _Album
    let year : String
    let tracks : [Track]
    
    init(artist: Artist, album: _Album, year: String, tracks: [Track]) {
        self.artist = artist
        self.album = album
        self.year = year
        self.tracks = tracks
    }
}
