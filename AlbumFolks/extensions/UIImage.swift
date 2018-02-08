//
//  UIImage.swift
//  AlbumFolks
//
//  Created by NTW-laptop on 08/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit

extension UIImage {
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
