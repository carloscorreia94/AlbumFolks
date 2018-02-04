//
//  AlertDialog.swift
//  AlbumFolks
//
//  Created by NTW-laptop on 04/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit

class AlertDialog {
    class func present(title: String,message: String, vController: UIViewController, action: ((UIAlertAction) -> ())? = nil) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: action))
        vController.present(ac, animated: true, completion: nil)
    }
}
