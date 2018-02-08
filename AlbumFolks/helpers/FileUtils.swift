//
//  FileUtils.swift
//  AlbumFolks
//
//  Created by NTW-laptop on 07/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit

class FileUtils {
    static let ALBUM_FILE = "album_%@.jpg"
    static let ALBUMS_FOLDER = "albums"

    
    static func deleteFile(file: URL) -> Bool {
        let fileManager = FileManager.default
        
        do {
            try fileManager.removeItem(at: file)
            print("deleted file \(file.absoluteString)")
            return true
        } catch let error as NSError {
            print(error.debugDescription)
            return false
        }
    }
    
    static func getFile(name: String, folder: String? = nil) -> URL? {
        var documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        if let folder = folder {
            documentsUrl = documentsUrl.appendingPathComponent(folder)
        }
        
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            
            if let index = directoryContents.index(where: {$0.lastPathComponent == name }) {
                return directoryContents[index]
            }
            return nil
            
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
