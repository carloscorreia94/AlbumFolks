//
//  UICollectionViewFlowDelegateAlbum.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 02/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit

// TODO : Explain this, and the flowDelegateHandler in the appropriate classes
class UICollectionViewFlowDelegateHandler :  NSObject, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width / 2.0
        let cellHeight = cellWidth * (17/15) // ratio as explicitly defined in the AlbumView Layout
        
        return CGSize(width: cellWidth - 8, height: cellHeight)
    }
    
}

protocol UICollectionViewFlowDelegateAlbums {
    var flowDelegateHandler: UICollectionViewFlowDelegateHandler! {get set}
    mutating func useProtocolForCollectionView(collectionView: UICollectionView)
}

extension UICollectionViewFlowDelegateAlbums {
    mutating func useProtocolForCollectionView(collectionView: UICollectionView) {
        flowDelegateHandler = UICollectionViewFlowDelegateHandler()
        collectionView.delegate = flowDelegateHandler
    }
}
