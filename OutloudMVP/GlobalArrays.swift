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
    var isRead : Bool?
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

struct ReadingListStruct {
    var uuid : String?
    var articleID : String?
    var isHuman : Bool?
    var readerID : String?
    var contentUrl : String?
    var url : String?
    var fileType : String?
}
//var CacheValidationArray = [CacheValidation]()

var CacheValidationArray : NSMutableArray = []
var CacheValidationNSArray : NSArray = []

var ArticleListArray = [ArticleListStruct]()
var ArticleDetailArray = [ArticleDetailStruct]()
var FullArticleContentArray = [FullArticleContent]()
var ArticleDetailMediaArray = [ArticleDetailMedia]()
var ArticleDetailMediaMetadataArray = [ArticleDetailMediaMetadata]()

var WebViewFullArticleContentArray = [FullArticleContent]()

var ArticleListMediaArray = [ArticleDetailMedia]()
var ArticleListMediaMetadataArray = [ArticleDetailMediaMetadata]()

var ReadingsListArray = [ReadingListStruct]()

var articleDetailDictionary :[String: AnyObject] = ["place":"holder"]

var ParagraphCount = 0
var CurrentArticleUuid :String? = nil
var indexToListenAt = 0



func generateCustomCellRecording() {
    let uuid = "", source = "", popularity = "", section = "", title = "Custom Article", author = "", abstract = "Click on this cell to navigate to any article online!  Record yourself by paragraphs and submit it!  We'll feature it on the app once we verify it!", url = "www.outloud.io", byline = "", updated_date = "", created_date = "", published_date = "", isRead = false, type = "", subtype = "", caption = "", copyright = "", imageurl = "", format = "", height = 0, width = 0
    
    
    let newMediaMetadata = ArticleDetailMediaMetadata(url: imageurl, format: format, height: height, width: width)
    ArticleListMediaMetadataArray.append(newMediaMetadata)
    
    let newMedia = ArticleDetailMedia(type: type, subtype: subtype, caption: caption, copyright: copyright, mediaMetadata: ArticleDetailMediaMetadataArray)
    ArticleListMediaArray.append(newMedia)
    

    let newArticle = ArticleListStruct(uuid: uuid, source: source, popularity: popularity, section: section, title: title, author: author, abstract: abstract, url: url, byline: byline, updated_date: updated_date, created_date: created_date, published_date: published_date, media: ArticleListMediaArray, isRead: isRead)
    ArticleListArray.append(newArticle)
}