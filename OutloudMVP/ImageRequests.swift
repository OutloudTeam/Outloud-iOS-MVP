//
//  ImageRequests.swift
//  OutloudMVP
//
//  Created by Frederik Lohner on 28/Oct/15.
//  Copyright © 2015 Outloud. All rights reserved.
//

import Foundation
import UIKit
import Haneke
func downloadAndCacheImage(articleImage: UIImageView, indexPath: NSIndexPath) {
    if let urlString = ArticleListMediaMetadataArray[indexPath.row].url {
        articleImage.hnk_setImageFromURL(NSURL(string: urlString)!)
    }
    
//    let cache = Shared.imageCache
//    let iconFormat = Format<UIImage>(name: "articleListIcons", diskCapacity: 10 * 1024 * 1024) { image in
//        return image
//    }
//    cache.addFormat(iconFormat)
//    
//    guard let URL = NSURL(string: urlString)! as? NSURL else {
//        return
//    }
//    cache.fetch(URL: URL, formatName: "icons").onSuccess { image in
//        articleImage.image = image
//    }
    
//    let URL = NSURL(string: "\(article))!
//    cache.fetch(URL: URL, formatName: "icons").onSuccess { image in
//        // image will be a nice rounded icon
//    }
}