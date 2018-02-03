//
//  String.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 03/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import Foundation

extension String {
    
    // MARK : helper methods for everchanging string manipulation mechanisms on the Swift Journey
    
        subscript(value: PartialRangeUpTo<Int>) -> Substring {
            get {
                return self[..<index(startIndex, offsetBy: value.upperBound)]
            }
        }
        
        subscript(value: PartialRangeThrough<Int>) -> Substring {
            get {
                return self[...index(startIndex, offsetBy: value.upperBound)]
            }
        }
        
        subscript(value: PartialRangeFrom<Int>) -> Substring {
            get {
                return self[index(startIndex, offsetBy: value.lowerBound)...]
            }
        }
    
    public func trim(to maximumCharacters: Int) -> String {
        return self.count > maximumCharacters ? self[...maximumCharacters] + "..." : self
    }
    
}
