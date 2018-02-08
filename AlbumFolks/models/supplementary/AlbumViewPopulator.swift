//
//  AlbumPopulator.swift
//  AlbumFolks
//
//  Created by NTW-laptop on 08/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit

class AlbumViewPopulator {
    var image : UIImage?
    var name : String
    var tags : String?
    var hashString : String
    var storedAlbum : AlbumMO?
    var tracks = [TrackViewPopulator]()
    var artist : ArtistPopulator
    var localMode = false

    init(album: Album, image: UIImage? = nil) {
        self.image = image
        self.name = album.name
        self.tags = album.albumDetail!.getTagsString()
        self.artist = ArtistPopulator(name: album.artist.name, mbid: album.artist.mbid, photoUrl: album.artist.photoUrl, lastFmUrl: album.artist.lastFmUrl)
        self.hashString = String(album.hashValue)
        self.storedAlbum = AlbumMO.get(from: self.hashString)

        
        for _track in album.albumDetail!.tracks {
            let track = TrackViewPopulator(number: _track.number, title: _track.title, lengthStatic: _track.lengthStatic)
            self.tracks.append(track)
        }
    }
    
    init(albumMO: AlbumMO, image: UIImage? = nil) {
        self.image = image
        self.name = albumMO.name!
        self.tags = albumMO.tags
        
        self.artist = ArtistPopulator(name: albumMO.artist!.name!, mbid: albumMO.artist!.mbid!, photoUrl: albumMO.artist!.getPhotoUrl(), lastFmUrl: albumMO.artist!.getLastFmUrl())
        self.hashString = String(albumMO.stringHash!)
        self.storedAlbum = albumMO
        
        let _tracks = (albumMO.tracks as! Set<TrackMO>).sorted(by: { $0.number < $1.number })
        for _track in _tracks {
            let track = TrackViewPopulator(number: Int(_track.number), title: _track.title, lengthStatic: _track.lengthStatic)
            self.tracks.append(track)
        }
        self.localMode = true
    }
}


struct TrackViewPopulator {
    var number: Int!
    var title: String!
    var lengthStatic: String?
}

struct ArtistPopulator {
    let name, mbid : String
    var photoUrl, lastFmUrl : URL?
}
