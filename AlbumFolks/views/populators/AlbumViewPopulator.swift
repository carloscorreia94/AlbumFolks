//
//  AlbumViewPopulator.swift
//  AlbumFolks
//
//  Created by NTW-laptop on 17/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//


class AlbumViewPopulator {
    var inMemoryImage : UIImage?
    var photoUrl : URL?
    var name : String
    var tags : String?
    var hashString : String
    var storedAlbum : AlbumMO?
    var tracks = [TrackViewPopulator]()
    var artist : ArtistPopulator
    var localMode = false
    
    init(album: Album, image: UIImage? = nil) {
        
        self.inMemoryImage = image
        self.photoUrl = album.photoUrl
        self.name = album.name
        self.artist = ArtistPopulator(name: album.artist.name, mbid: album.artist.mbid, photoUrl: album.artist.photoUrl, lastFmUrl: album.artist.lastFmUrl)
        self.hashString = String(album.hashValue)
        self.storedAlbum = AlbumMO.get(from: self.hashString)
        
        guard let detail = album.albumDetail else {
            assertionFailure("Couldn't fetch album detail")
            return
        }
        
        self.tags = detail.getTagsString()
        
        
        for _track in detail.tracks {
            let track = TrackViewPopulator(number: _track.number, title: _track.title, lengthStatic: _track.lengthStatic)
            self.tracks.append(track)
        }
    }
    
    init(albumMO: AlbumMO, image: UIImage? = nil) {
        self.inMemoryImage = image
        self.photoUrl = albumMO.photoUrl != nil ? URL(string: albumMO.photoUrl!) : nil
        self.name = albumMO.name ?? ""
        self.tags = albumMO.tags
        
        self.artist = ArtistPopulator(name: albumMO.artist?.name ?? "", mbid: albumMO.artist?.mbid ?? "", photoUrl: albumMO.artist?.getPhotoUrl(), lastFmUrl: albumMO.artist?.getLastFmUrl())
        
        if let hash = albumMO.stringHash {
            self.hashString = hash
        } else {
            self.hashString = String(UInt32(name.hashValue) ^ (arc4random_uniform(UInt32(name.count)) + arc4random_uniform(100)))
        }
        
        self.storedAlbum = albumMO
        
        let _tracks = (albumMO.tracks as! Set<TrackMO>).sorted(by: { $0.number < $1.number })
        for _track in _tracks {
            let track = TrackViewPopulator(number: Int(_track.number), title: _track.title, lengthStatic: _track.lengthStatic)
            self.tracks.append(track)
        }
        self.localMode = true
    }
}
