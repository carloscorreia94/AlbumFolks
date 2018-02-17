# Implementation Details

Follow some notes on this implementation that I consider important for the overall solid UX/code base.

## ViewPopulators

Defined inside group views/populators for the ease of view data injection. Abstraction to allow for smooth data injection within the AlbumVC. Also, because an user can be redirected from the RecentSearches or Stored Albums to the Artist Page, ArtistViewPopulator struct gets to be populated outside the normal context (Albums CollectionView click - either on StoredAlbumsVC or ArtistAlbumsVC)

## Album Identifiers

An album (coming from LastFM Api upon collective album info request for the artist) gets identified by either it's mbid (musicbrainzid) or combination name&&artist-name. There's a lot of albums with no associated mbid that can get their detail fetched anyways. So I resourced to this knowledge and created a hashValue for the album based on having associated mbid or just the string identifier. So the appropriate resource gets called upon AlbumDetail fetch. 


## Lazy Album Info Download

You may have noticed that there's no loading associated for the AlbumVC. This is because I download the album detail info as the user navigates through the albums information (ArtistAlbumVC). This way we have a more fluid experience.

## ImageDownload Mechanism

At the time of this implementation I wasn't sure if AlamofireImage would store the album art undefinetelly or just cache it, so I resourced to my own mechanism of file storage. If an album gets downloaded, having an available cover art, it gets saved to the device (upon image download by Alamofire). When loading downloaded album info (initial page), I try to locate it's photo (based on the hashValue). In the negative case, having a photoURL associated (stored attribute), we try to fetch the image again and download it. The reason for this, is that sometimes I experienced failures on imageDownload from the API or even storage by the iOS FileSystem API.