//
//  Track.swift
//  AlbumFolks
//
//  Created by NTW-laptop on 04/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import ObjectMapper
import Alamofire

class Track : Mappable {
    
    var number: Int!
    var title: String!
    var lengthStatic: String?
    
    required init?(map: Map){
        
        guard let _: String = map["name"].value() else {
            return nil
        }
        
        guard let rank: String = map["@attr.rank"].value(), let _ : Int = Int(rank) else {
            return nil
        }
    }
    
    
    func mapping(map: Map) {
        let rank : String = map["@attr.rank"].value()!
        number = Int(rank)!
        title <- map["name"]
        
        if let duration : String = map["duration"].value(), let intDuration = Int(duration) {
            lengthStatic = stringFromTimeIn(seconds: intDuration)
        }

    }
    
    private func stringFromTimeIn(seconds : Int) -> String {
        let hourTime = seconds / 3600
        let secondTime = (seconds % 3600) % 60
        let secondFormattedTime = secondTime < 10 ? "0\(secondTime)" : "\(secondTime)"
        
        if hourTime < 1 {
            return "\((seconds % 3600) / 60):\(secondFormattedTime)"
        } else {
            return "\(hourTime):\((seconds % 3600) / 60):\(secondFormattedTime)"
        }
    }
}
