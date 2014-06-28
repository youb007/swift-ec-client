//
//  ImageCache.swift
//  SwiftECClient
//
//  Created by naoto yamaguchi on 2014/06/26.
//  Copyright (c) 2014 naoto yamaguchi. All rights reserved.
//

import UIKit

class ImageCache: NSObject {
    
    var imageCache: Dictionary<NSIndexPath, UIImage> = Dictionary<NSIndexPath, UIImage>()
        
    func dequeueImageByIndexPath(indexPath: NSIndexPath) -> UIImage? {
        
        if let validImage = self.imageCache[indexPath] {
            return validImage as UIImage
        }
        else {
            return nil
        }
        
    }
    
    func enqueueImage(image: UIImage, indexPath: NSIndexPath){
        self.imageCache[indexPath] = image
    }
    
}
