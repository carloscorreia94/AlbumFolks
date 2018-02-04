//
//  LoadingAnimation.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 03/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit

class LoadingIndicatorView {
    class func create(centerX: CGFloat, originY: CGFloat, size: CGFloat) -> UIView {
        let loadingView = UIView()
        loadingView.frame = CGRect(origin: CGPoint(x: 0,y: originY), size: CGSize(width: size,height: size))
        loadingView.center.x = centerX
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: 30,height: 30))
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2,
                                y: loadingView.frame.size.height / 2)
        loadingView.addSubview(actInd)
        actInd.startAnimating()
        
        return loadingView
    }
}
