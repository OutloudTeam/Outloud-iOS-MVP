//
//  JSONRequests.swift
//  OutloudMVP
//
//  Created by Frederik Lohner on 20/Oct/15.
//  Copyright © 2015 Outloud. All rights reserved.
//

import Foundation
import SwiftyJSON
import Haneke

// MARK: - Generates Article JSON from article ID
// TODO: - Implement cache refresh after a while
func articleJSONGet(inout articleDictionary: Dictionary<String,AnyObject>, articleID: String, success:()->()) {
    let urlString = "http://www.outloud.io:8080/api/article/" + articleID
    let cache = Cache<NSData>(name: "articleCache")
    let URL = NSURL(string: urlString)!
    
    cache.fetch(URL: URL).onSuccess { (Data) -> () in
        let articleDetailJSONDict = JSON(data: Data)
        ArticleDetailArray.removeAll()
        let uuid = articleDetailJSONDict["uuid"].string
        let source = articleDetailJSONDict["source"].string
        let popularity = articleDetailJSONDict["popularity"].string
        let section = articleDetailJSONDict["section"].string
        let title = articleDetailJSONDict["title"].string
        let author = articleDetailJSONDict["author"].string
        let abstract = articleDetailJSONDict["abstract"].string
        let fullContent = articleDetailJSONDict["full_content"]
        let url = articleDetailJSONDict["url"].string
        let byline = articleDetailJSONDict["byline"].string
        let updated_date = articleDetailJSONDict["updated_date"].string
        let created_date = articleDetailJSONDict["created_date"].string
        let published_date = articleDetailJSONDict["published_date"].string
        let media = articleDetailJSONDict["media"]
        FullArticleContentArray.removeAll()
        for var i = 0; i < fullContent.count; i++ {
            let text = articleDetailJSONDict["full_content"][i]["text"].string
            //                    let readings = articleDetailJSONDict["full_content"][i]["readings"]
            
            let newContent = FullArticleContent(text: text, readings: nil, recordingUrl: nil)
            FullArticleContentArray.append(newContent)
        }
        ArticleDetailMediaArray.removeAll()
        ArticleDetailMediaMetadataArray.removeAll()
        for var i = 0; i < articleDetailJSONDict["media"].count; i++ {
            let type = media[i]["type"].string
            let subtype = media[i]["subtype"].string
            let caption = media[i]["caption"].string
            let copyright = media[i]["copyright"].string
            let mediaMetadata = articleDetailJSONDict["media"][i]["media-metadata"]
            for var z = 0; z < mediaMetadata.count; z++ {
                let url = media[i]["media-metadata"][z]["url"].string
                let format = media[i]["media-metadata"][z]["format"].string
                let height = media[i]["media-metadata"][z]["height"].int
                let width  = media[i]["media-metadata"][z]["width"].int
                
                let newMediaMetadata = ArticleDetailMediaMetadata(url: url, format: format, height: height, width: width)
                ArticleDetailMediaMetadataArray.append(newMediaMetadata)
                
            }
            let newMedia = ArticleDetailMedia(type: type, subtype: subtype, caption: caption, copyright: copyright, mediaMetadata: ArticleDetailMediaMetadataArray)
            ArticleDetailMediaArray.append(newMedia)
            
        }
        let newArticleDetail = ArticleDetailStruct(uuid: uuid, source: source, popularity: popularity, section: section, title: title, author: author, abstract: abstract, fullContent: FullArticleContentArray, url: url, byline: byline, updated_date: updated_date, created_date: created_date, published_date: published_date, media: ArticleDetailMediaArray)
        ArticleDetailArray.append(newArticleDetail)
        success()
    }
}
// MARK: - Generate article list from API
func articleListJSONGet(read: Bool, forceRefresh: Bool, success:()->()) {
    var urlString = ""
    if read == true {
        urlString = "http://www.outloud.io:8080/api/feed/"
    } else {
        urlString = "http://www.outloud.io:8080/api/feed?is_read=false"
    }
    let cache = Shared.dataCache
    if(cacheCheck() == false || forceRefresh == true){
        cache.removeAll()
        removeTime(0)
        writeTime(currentYearDayHourMinute())
    }
    let URL = NSURL(string: urlString)!
    cache.fetch(URL: URL).onSuccess { (Data) -> () in
        
        let articleListJSONDict = JSON(data: Data)
        let articleListCount = articleListJSONDict.count
        ArticleListArray.removeAll()
        ArticleListMediaArray.removeAll()
        ArticleListMediaMetadataArray.removeAll()
        if read == false {
            generateCustomCellRecording()
        }
        for var i = 0; i < articleListCount; i++ {
            let uuid = articleListJSONDict[i]["uuid"].string
            let source = articleListJSONDict[i]["source"].string
            let popularity = articleListJSONDict[i]["popularity"].string
            let section = articleListJSONDict[i]["section"].string
            let title = articleListJSONDict[i]["title"].string
            let author = articleListJSONDict[i]["author"].string
            let abstract = articleListJSONDict[i]["abstract"].string
            let url = articleListJSONDict[i]["url"].string
            let byline = articleListJSONDict[i]["byline"].string
            let updated_date = articleListJSONDict[i]["updated_date"].string
            let created_date = articleListJSONDict[i]["created_data"].string
            let published_date = articleListJSONDict[i]["published_date"].string
            let media = articleListJSONDict[i]["media"]
            let isRead = articleListJSONDict[i]["is_read"].bool
            //            for var z = 0; z < articleListJSONDict["media"].count; z++ {
            let type = media[0]["type"].string
            let subtype = media[0]["subtype"].string
            let caption = media[0]["caption"].string
            let copyright = media[0]["copyright"].string
            let mediaMetadata = articleListJSONDict["media"][0]["media-metadata"]
            //                for var p = 0; p < mediaMetadata.count; p++ {
            let imageurl = media[0]["media-metadata"][0]["url"].string
            let format = media[0]["media-metadata"][0]["format"].string
            let height = media[0]["media-metadata"][0]["height"].int
            let width  = media[0]["media-metadata"][0]["width"].int
            
            let newMediaMetadata = ArticleDetailMediaMetadata(url: imageurl, format: format, height: height, width: width)
            ArticleListMediaMetadataArray.append(newMediaMetadata)
            //
            //                }
            let newMedia = ArticleDetailMedia(type: type, subtype: subtype, caption: caption, copyright: copyright, mediaMetadata: ArticleDetailMediaMetadataArray)
            ArticleListMediaArray.append(newMedia)
            
            //            }
            let newArticle = ArticleListStruct(uuid: uuid, source: source, popularity: popularity, section: section, title: title, author: author, abstract: abstract, url: url, byline: byline, updated_date: updated_date, created_date: created_date, published_date: published_date, media: ArticleListMediaArray, isRead: isRead)
            ArticleListArray.append(newArticle)
        }
        success()
    }
}

// MARK: - Generate article list from API
func readingsListGet(success:()->()) {
    let urlString = "http://www.outloud.io:8080/api/readings"
    let cache = Shared.dataCache
    if(cacheCheck() == false){
        cache.removeAll()
        removeTime(0)
        writeTime(currentYearDayHourMinute())
    }
    let URL = NSURL(string: urlString)!
    cache.fetch(URL: URL).onSuccess { (Data) -> () in
        let readingsListJSON = JSON(data: Data)
        let articleListCount = readingsListJSON.count
        ReadingsListArray.removeAll()
        for var i = 0; i < articleListCount; i++ {
            let uuid = readingsListJSON[i]["uuid"].string
            let articleID = readingsListJSON[i]["article_id"].string
            let isHuman = readingsListJSON[i]["is_human"].bool
            let readerID = readingsListJSON[i]["reader_id"].string
            let contentUrl = readingsListJSON[i]["content_url"].string
            let url = readingsListJSON[i]["url"].string
            let fileType = readingsListJSON[i]["file_type"].string
            
            let newArticle = ReadingListStruct(uuid: uuid, articleID: articleID, isHuman: isHuman, readerID: readerID, contentUrl: contentUrl, url: url, fileType: fileType)
            ReadingsListArray.append(newArticle)
        }
        success()
    }
}