//
//  JSONRequests.swift
//  OutloudMVP
//
//  Created by Frederik Lohner on 20/Oct/15.
//  Copyright © 2015 Outloud. All rights reserved.
//

import Foundation

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
//                print(articleDictionary)
                // here "decoded" is the dictionary decoded from JSON data
                success()
            } catch let error as NSError {
                print(error)
            }
        }
    }
    task.resume()
}

func articleListJSONGet() {
    func articleJSONGet(success:()->()) {
        let urlString = "http://imgonnahaveahouse.party:8080/api/feed"
        
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
                    print(decoded)                    //                print(articleDictionary)
                    // here "decoded" is the dictionary decoded from JSON data
                    success()
                } catch let error as NSError {
                    print(error)
                }
            }
        }
        task.resume()
    }
}