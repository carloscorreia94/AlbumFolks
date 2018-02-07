//
//  ImageFileUtils.swift
//  AlbumFolks
//
//  Created by NTW-laptop on 07/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit

class ImageFileUtils {
    static let COMPRESSION_QUALITY_FOR_IMAGE : CGFloat = 1.0

    static func saveImage(image: UIImage, path: String, folder: String?) -> URL? {
        var documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        if let fold = folder {
            documentsDirectoryURL = documentsDirectoryURL.appendingPathComponent(fold)
            do {
                try FileManager().createDirectory(atPath: documentsDirectoryURL.path, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
            }
        }
        
        let fileURL = documentsDirectoryURL.appendingPathComponent(path)
        
        var compression = ImageFileUtils.COMPRESSION_QUALITY_FOR_IMAGE
        let maxFileSize = 600*1024
        var imageData = UIImageJPEGRepresentation(image, compression)
        
        while (imageData!.count > maxFileSize)
        {
            compression = compression * 0.1;
            imageData = UIImageJPEGRepresentation(image, compression)
        }
        
        do {
            try imageData?.write(to: fileURL, options: [.atomic])
            print("saved image \(fileURL.absoluteString)")
            return fileURL.absoluteURL
        } catch {
            return nil
        }
    }

}


