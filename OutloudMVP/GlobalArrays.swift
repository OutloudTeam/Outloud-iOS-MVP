//
//  GlobalArrays.swift
//  OutloudMVP
//
//  Created by Frederik Lohner on 20/Oct/15.
//  Copyright © 2015 Outloud. All rights reserved.
//

import Foundation

struct CacheValidation {
    var type : String?
    var time : Int?
}

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
    var media = [ArticleDetailMedia]()
}

struct ArticleDetailStruct {
    var uuid : String?
    var source : String?
    var popularity : String?
    var section : String?
    var title : String?
    var author : String?
    var abstract : String?
    var fullContent = [FullArticleContent]()
    var url : String?
    var byline : String?
    var updated_date : String?
    var created_date : String?
    var published_date : String?
    var media = [ArticleDetailMedia]()
}

struct ArticleDetailMedia {
    var type : String?
    var subtype : String?
    var caption : String?
    var copyright : String?
    var mediaMetadata = [ArticleDetailMediaMetadata]()
}

struct ArticleDetailMediaMetadata {
    var url : String?
    var format : String?
    var height : Int?
    var width : Int?
}

struct FullArticleContent {
    var text : String?
    var readings : String?
    var recordingUrl : NSURL?
}
//var CacheValidationArray = [CacheValidation]()

var CacheValidationArray : NSMutableArray = []
var CacheValidationNSArray : NSArray = []

var ArticleListArray = [ArticleListStruct]()
var ArticleDetailArray = [ArticleDetailStruct]()
var FullArticleContentArray = [FullArticleContent]()
var ArticleDetailMediaArray = [ArticleDetailMedia]()
var ArticleDetailMediaMetadataArray = [ArticleDetailMediaMetadata]()

var ArticleListMediaArray = [ArticleDetailMedia]()
var ArticleListMediaMetadataArray = [ArticleDetailMediaMetadata]()

var articleDetailDictionary :[String: AnyObject] = ["place":"holder"]

var ParagraphCount = 0
