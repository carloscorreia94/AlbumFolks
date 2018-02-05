//
//  CoreNetwork.swift
//  AlbumFolks
//
//  Created by NTW-laptop on 04/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import Alamofire


enum NetworkError {
    case Connection, ServerError, NotFound, UnexpectedJSON, Authorization, WrongContent
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
        case .WrongContent:
            return NetworkErrorMessage(title: "Content Error", desc: "Are you inputing wrong/bad content? Try again")
        default:
            return NetworkErrorMessage(title: "Server Error", desc: "Unexpected content coming from the server. Wait for the next update :))")
        }
    }
    
   

    static func handleResponse<T>(_ response: DataResponse<T>) -> (T?,NetworkError?) {
        
        let status = response.response?.statusCode
        switch status ?? -1 {
        case 403:
            return (nil,.Authorization)
        case 500:
            return (nil,.ServerError)
        case 404:
            return (nil,.NotFound)
        case 200:
            if let x : T = response.result.value {
                return (x,nil)
            } else {
                return (nil,.UnexpectedJSON)
            }
            //No internet connection here
        case -1:
            return (nil,.Connection)
        default:
            if (response.result.error != nil) {
                return (nil,.Connection)
            } else {
                return (nil,.ServerError)
            }
        }
    }

}
