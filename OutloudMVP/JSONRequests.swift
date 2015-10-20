//
//  JSONRequests.swift
//  OutloudMVP
//
//  Created by Frederik Lohner on 20/Oct/15.
//  Copyright © 2015 Outloud. All rights reserved.
//

import Foundation

func articleJSONGet(success:()->()) {
    let urlString = "http://imgonnahaveahouse.party:8080/api/article/9a4cdd09-f1c7-4ffa-8bb1-f3f61603a6b0"
    
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
            //            let dataString2 = NSString(data: dataFromStringUTF!, encoding: NSUTF8StringEncoding)
            guard let jsonDict : NSMutableDictionary = try? NSJSONSerialization.JSONObjectWithData(dataFromStringUTF, options: NSJSONReadingOptions.MutableContainers) as! NSMutableDictionary else {
                return
            }
            print(jsonDict)
        }
    }
    task.resume()
}