//
//  CoreNetwork.swift
//  AlbumFolks
//
//  Created by NTW-laptop on 04/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import Alamofire


enum NetworkError {
    case Connection, ServerError, NotFound, UnexpectedJSON, Authorization
}

class CoreNetwork {
    
    struct NetworkErrorMessage {
        let title: String
        let desc: String
    }
    
    static func messageFromError(_ error: NetworkError) -> NetworkErrorMessage {
        switch error {
        case .Connection:
            return NetworkErrorMessage(title: "Connection Error", desc: "Check your connection and load this page again")
        case .NotFound:
            return NetworkErrorMessage(title:"Error", desc: "Server not found. That's strange.")
        case .ServerError:
            return NetworkErrorMessage(title: "Server Error", desc: "Contact the app administrator - We mean LastFM :-)")
        case .Authorization:
            return NetworkErrorMessage(title: "Authentication Error", desc: "API Key has expired? Build the app with your own API_KEY")
        default:
            return NetworkErrorMessage(title: "Server Error", desc: "Unexpected content coming from the server. Wait for the next update :))")
        }
    }
    
    struct COMMON_KEYS {
        static let API_KEY = "api_key"
        static let METHOD_KEY = "method"
        static let FORMAT_KEY_AND_VALUE = "format=json"
        static let ID = "mbid"
    }
    
    struct API_URLS {
        static let ArtistDetail = API_URL_FORMAT_AND_METHOD + "artist.getinfo&mbid=%@"
        static let ArtistAlbums = API_URL_FORMAT_AND_METHOD + "artist.getTopAlbums&mbid=%@"
    }
    
    static let API_URL = "https://ws.audioscrobbler.com/2.0/"
    static let API_URL_WITH_API_KEY = API_URL + "?\(COMMON_KEYS.API_KEY)=\(API_KEY_VALUE)"
    static let API_URL_FORMAT = API_URL_WITH_API_KEY + "&\(COMMON_KEYS.FORMAT_KEY_AND_VALUE)"
    static let API_URL_FORMAT_AND_METHOD = API_URL_FORMAT + "&\(COMMON_KEYS.METHOD_KEY)="

    static let API_KEY_VALUE = "817be21ebea3ab66566f275369c6c4ad"

    static func handleResponse<T>(_ response: DataResponse<T>) -> (T?,NetworkError?) {
        if (response.result.error != nil) {
            
            return (nil,.Connection)
            
        }
        let status = response.response?.statusCode
        switch status! {
        case 401:
            return (nil,.Authorization)
        case 500:
            return (nil,.ServerError)
        case 404:
            return (nil,.NotFound)
        default:
            if let x : T = response.result.value {
                return (x,nil)
            } else {
                return (nil,.UnexpectedJSON)
            }
        }
    }

}
