//
//  GloablFunctions.swift
//  OutloudMVP
//
//  Created by Frederik Lohner on 15/Oct/15.
//  Copyright © 2015 Outloud. All rights reserved.
//

import Foundation
import UIKit
func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

/* Give the text, font and width of the label returns height for view,
used for dynamically allocating height for cells.
*/
func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.ByWordWrapping
    label.font = font
    label.text = text
    
    label.sizeToFit()
    return label.frame.height
}

func transformIntoJustified(label: UILabel, lineSpace: Int) {
    label.lineBreakMode = NSLineBreakMode.ByWordWrapping
    label.numberOfLines = 0
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .Justified
    paragraphStyle.lineSpacing = CGFloat(lineSpace)
    paragraphStyle.firstLineHeadIndent = 0.001
    
    let mutableAttrStr = NSMutableAttributedString(attributedString: label.attributedText!)
    mutableAttrStr.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, mutableAttrStr.length))
    label.attributedText = mutableAttrStr
}

func heightForJustifiedView(text:String, font:UIFont, width:CGFloat, lineSpace: Int) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
    label.text = text
    transformIntoJustified(label,lineSpace: lineSpace)
    
    label.font = font
    
    
    label.sizeToFit()
    return label.frame.height
}


func roundUp(value: Int, divisor: Int) -> Int {
    let rem = value % divisor
    return rem == 0 ? value : value + divisor - rem
}

func writeTime(time: Int) {
    let file = "cacheCheck.plist"
    if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
        let path = dir.stringByAppendingPathComponent(file)
        do {
            CacheValidationArray.addObject(time)
            CacheValidationNSArray = CacheValidationArray
            CacheValidationNSArray.writeToFile(path, atomically: true)
        }
    }
}
func removeTime(index: Int) {
    CacheValidationArray.removeObjectAtIndex(index)
}


func currentYearDayHourMinute()->Int {
    let calendar = NSCalendar.currentCalendar()
    let date = NSDate()
    let components = calendar.components([.Minute, .Hour, .Day, .Year], fromDate: date)
    return roundUp(components.minute, divisor: 10) + (components.hour * 100) + (components.day * 10000) + (components.year * 1000000)
}

func readCacheTime()->Int {
    let file = "cacheCheck.plist"
    if let dir : NSString = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
        let path = dir.stringByAppendingPathComponent(file)
        do {
            if let CacheValidationNSArray = NSArray(contentsOfFile: path) {
                CacheValidationArray = CacheValidationNSArray as! NSMutableArray
                if(CacheValidationArray[0] as! NSNumber == -20) {
                    removeTime(0)
                    writeTime(currentYearDayHourMinute())
                }
            } else {
                writeTime(-20)
                cacheCheck()
            }
        }
    }
    return Int(CacheValidationArray[0] as! NSNumber)
}

func cacheCheck()->Bool {
    if(readCacheTime() != currentYearDayHourMinute()) {
        print("Cache is invalid")
        return false
    } else {
        print("Cache is still valid")
        return true
    }
}