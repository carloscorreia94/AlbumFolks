//
//  AlbumHeaderCell.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 26/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

class AlbumHeaderCell : UITableViewCell {
    
    static let REUSE_ID = String(describing: AlbumHeaderCell.self)

    @IBOutlet weak var saveSwitch: UISwitch!
    var saveCallback : (() -> ())!
    var deleteCallback: (() -> ())!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        saveSwitch.addTarget(self, action: #selector(stateChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func stateChanged(switchState: UISwitch) {
        if !switchState.isOn {
            deleteCallback()
        } else {
            saveCallback()
        }
    }
}
