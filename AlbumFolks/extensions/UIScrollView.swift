//
//  UIScrollView.swift
//  AlbumFolks
//
//  Created by NTW-laptop on 18/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import Foundation

extension UIScrollView {
    
    func canScrollDown() -> Bool {
        
        if (self.contentOffset.y<=0) {
            self.contentOffset = CGPoint.zero
        }
        
        let height = self.frame.size.height
        let contentYoffset = self.contentOffset.y
        let distanceFromBottom = self.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            return true
        }
        return false
    }
}
