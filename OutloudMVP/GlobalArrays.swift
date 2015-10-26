//
//  GlobalArrays.swift
//  OutloudMVP
//
//  Created by Frederik Lohner on 20/Oct/15.
//  Copyright © 2015 Outloud. All rights reserved.
//

import Foundation

struct ArticleListStruct {
    var uuid : String?
    var source : String?
    var popularity : String?
    var section : String?
    var title : String?
    var author : String?
    var abstract : String?
    var url : String?
    var byline : String?
    var updated_date : String?
    var created_date : String?
    var published_date : String?
}

var ArticleListArray = [ArticleListStruct]()