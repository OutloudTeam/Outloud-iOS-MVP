//
//  JSONRequests.swift
//  OutloudMVP
//
//  Created by Frederik Lohner on 20/Oct/15.
//  Copyright © 2015 Outloud. All rights reserved.
//

import Foundation
import SwiftyJSON

func articleJSONGet(inout articleDictionary: Dictionary<String,AnyObject>, articleID: String, success:()->()) {
    let urlString = "http://imgonnahaveahouse.party:8080/api/article/" + articleID
    
    let getURL = NSURL(string: urlString)
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithURL(getURL!) {
        (data, response, error) -> Void in
        
        if error != nil {
            print(error?.localizedDescription)
        } else {
            guard let data = data, dataString = NSString(data: data, encoding: NSISOLatin1StringEncoding) else {
                return
            }
            guard let dataFromStringUTF = dataString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) else {
                return
            }
            do {
                let decoded = try NSJSONSerialization.JSONObjectWithData(dataFromStringUTF, options: []) as? [String:AnyObject]
                articleDictionary = decoded!
                success()
            } catch let error as NSError {
                print(error)
            }
        }
    }
    task.resume()
}

func articleListJSONGet(success:()->()){
    let urlString = "http://www.outloud.io:8080/api/feed"
    
    let getURL = NSURL(string: urlString)
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithURL(getURL!) {
        (data, response, error) -> Void in
        
        if error != nil {
            print(error?.localizedDescription)
        } else {
            guard let JSONData = data else {
                return
            }
            do {
                _ = try NSJSONSerialization.JSONObjectWithData(JSONData, options: [])
                let articleListJSONDict = JSON(data: JSONData)
                let articleListCount = articleListJSONDict.count
                ArticleListArray.removeAll()
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
                    
                    let newArticle = ArticleListStruct(uuid: uuid, source: source, popularity: popularity, section: section, title: title, author: author, abstract: abstract, url: url, byline: byline, updated_date: updated_date, created_date: created_date, published_date: published_date)
                    ArticleListArray.append(newArticle)
                }
                success()
            } catch let error as NSError {
                print(error)
            }
        }
    }
    task.resume()
}
