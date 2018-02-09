# Album Folks

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

### Nothing at this point
