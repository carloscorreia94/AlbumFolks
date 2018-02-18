# Album Folks

This is merely a showcase app (for a company-test) gathering some of the most up-to-date iOS/Swift vocabulary by me (02-18). I do not hold any data rights concerning music information - I just use the publically available [LastFM API](https://www.last.fm/api/).

## Changelog

[Consult here](https://github.com/carloscorreia94/AlbumFolks/blob/master/CHANGELOG.md)

## Implementation Details

[Consult here](https://github.com/carloscorreia94/AlbumFolks/blob/master/ARCH.md)

## Key Features

* Smooth album info visualization/fetching from the LastFM API
* Album information download (along with cover art)

## To Use

* Change API_KEY in static/Constants.swift - API_KEY_VALUE for your own Last FM key - see [HERE](https://www.last.fm/api/authentication)

## Configurable Parameters 

### Search (SearchArtistsVC)

```Swift
/* When not searching */
static let MAX_RECENT_SEARCH_ENTRIES : Int

/* I recommend 2,3 minimum */
 static let MIN_SEARCH_QUERY_LENGTH : Int

/* Limit for the API Query - Limit number to display on the screen */
 static let MAX_SEARCH_RESULTS : Int

/* Last FM API present a lot of irrelevant pages w/unadmissible content... */
 static let MAX_PAGE_NUMBER : Int
 
/* load less pages as you write more content */
static let PAGE_DECREMENT_FACTOR_PER_EXTRA_CHAR : Int
```

### Artist Albums (ArtistAlbumsVC)

```Swift

/* After this threshold user gets a link displayed to open a webbrowser  */
static let MAX_ALBUMS_TO_SHOW : Int
```

## Dependencies

### Pods

* Alamofire
* AlamofireObjectMapper (and ObjectMapper)
* AlamofireImage
* PopupDialog

### Bridging Code (Copied Objective-C)

* UIScrollView+InfiniteScroll

## Testing
[AlbumVCEntryPointsTests.swift](https://github.com/carloscorreia94/AlbumFolks/tree/master/AlbumFolksTests/AlbumVCEntryPointsTests.swift) - Data flow testing corresponding to the core user interaction with the App i.e, visualize albums either from the API or saved.


