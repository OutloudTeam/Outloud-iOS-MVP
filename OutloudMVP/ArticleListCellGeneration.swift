//
//  ArticleListCellGeneration.swift
//  OutloudMVP
//
//  Created by Frederik Lohner on 26/Oct/15.
//  Copyright © 2015 Outloud. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

func generateReadingListCell(tableView: UITableView, indexPath: NSIndexPath)->UITableViewCell {
    let readingCell = UITableViewCell(style: .Default, reuseIdentifier: "readingCell")
    let readingTitle = UILabel()
    
    readingCell.addSubview(readingTitle)
    
    readingTitle.text = ReadingsListArray[indexPath.row].url
    readingTitle.adjustsFontSizeToFitWidth = true
    readingTitle.snp_makeConstraints { (make) -> Void in
        make.centerY.left.right.equalTo(readingCell)
        make.height.equalTo(30)
    }
    return readingCell
}


func generateArticleListListenCell(tableView: UITableView,indexPath: NSIndexPath)->UITableViewCell {
    let articleCell = UITableViewCell(style: .Default, reuseIdentifier: "articleCell")
    let articleTitle = UILabel()
    let articleAbstract = UILabel()
    let articleSeparatorBar = UIView()
    let articleRating = UIImageView()
    let playCountImage = UIImageView()
    let playCount = UILabel()
    let shareCountImage = UIImageView()
    let shareCount = UILabel()
    let articleOrigin = UILabel()
    let articleIcon = UIImageView()
//    let addToQueueIcon = UIImageView()
//    let addToQueueLabel = UILabel()
    
    articleCell.selectionStyle = .None
    
    articleIcon.frame = CGRectMake(0, 0, 85, 85)
    
    articleCell.addSubview(articleTitle)
    articleCell.addSubview(articleAbstract)
    articleCell.addSubview(articleSeparatorBar)
    articleCell.addSubview(articleRating)
    articleCell.addSubview(playCountImage)
    articleCell.addSubview(playCount)
    articleCell.addSubview(shareCountImage)
    articleCell.addSubview(shareCount)
    articleCell.addSubview(articleOrigin)
    articleCell.addSubview(articleIcon)
//    articleCell.addSubview(addToQueueIcon)
//    articleCell.addSubview(addToQueueLabel)
    
    
    articleTitle.text = ArticleListArray[indexPath.row].title
    articleAbstract.text = ArticleListArray[indexPath.row].abstract
    
    articleTitle.font = articleListTileFont
    articleTitle.textColor = UIColor.blackColor()
    articleAbstract.font = articleListAbstractFont
    articleAbstract.textColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
    
    transformIntoJustified(articleTitle, lineSpace: 0)
    transformIntoJustified(articleAbstract, lineSpace: 0)
    
    articleRating.image = UIImage(named: "rating")
    playCountImage.image = UIImage(named: "playCount")
    shareCountImage.image = UIImage(named: "sharedCount")
    
    let numberFormatter = NSNumberFormatter()
    numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
    let unitedStatesLocale = NSLocale(localeIdentifier: "en_US")
    numberFormatter.locale = unitedStatesLocale
    
    playCount.text = numberFormatter.stringFromNumber(NSNumber(unsignedInt: arc4random_uniform(456789)))
    shareCount.text = numberFormatter.stringFromNumber(NSNumber(unsignedInt: arc4random_uniform(212356)))
    playCount.adjustsFontSizeToFitWidth = true
    shareCount.adjustsFontSizeToFitWidth = true
    articleOrigin.adjustsFontSizeToFitWidth = true
    
    articleTitle.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(articleCell.snp_left).offset(15)
        make.right.equalTo(articleCell.snp_right).offset(-100)
        make.top.equalTo(articleCell.snp_top).offset(25)
    }
    articleAbstract.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(articleTitle.snp_left)
        make.right.equalTo(articleTitle.snp_right)
        make.top.equalTo(articleTitle.snp_bottom).offset(5)
    }
    articleRating.hidden = true
    playCountImage.hidden = true
    playCount.hidden = true
    shareCountImage.hidden = true
    shareCount.hidden = true
    
    articleRating.snp_makeConstraints { (make) -> Void in
        //        make.width.equalTo(50)
        make.height.equalTo(10)
        make.left.equalTo(articleTitle.snp_left)
        make.top.equalTo(articleAbstract.snp_bottom).offset(15)
    }
    playCountImage.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(articleRating.snp_right).offset(10)
        make.width.height.equalTo(10)
        make.centerY.equalTo(articleRating.snp_centerY)
    }
    playCount.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(playCountImage.snp_right).offset(5)
        make.centerY.equalTo(playCountImage.snp_centerY)
        make.width.equalTo(40)
    }
    shareCountImage.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(playCount.snp_right).offset(20)
        make.width.height.equalTo(playCountImage.snp_width)
        make.centerY.equalTo(articleRating.snp_centerY)
    }
    shareCount.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(shareCountImage.snp_right).offset(5)
        make.centerY.equalTo(shareCountImage.snp_centerY)
        make.width.equalTo(40)
    }
    articleOrigin.textAlignment = .Right
    articleOrigin.textColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
    articleOrigin.snp_makeConstraints { (make) -> Void in
        make.centerX.equalTo(articleIcon)
        make.top.equalTo(articleIcon.snp_bottom)
        make.width.equalTo(40)
    }
//
//    addToQueueIcon.image = UIImage(named: "plus")
//    addToQueueIcon.snp_makeConstraints { (make) -> Void in
//        make.left.equalTo(articleTitle)
//        make.height.width.equalTo(25)
//        make.bottom.equalTo(articleSeparatorBar).offset(-10)
//    }
//    addToQueueLabel.text = "Add to Queue"
//    addToQueueLabel.font = addToQueueFont
//    addToQueueLabel.textColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
//    addToQueueLabel.snp_makeConstraints { (make) -> Void in
//        make.centerY.equalTo(addToQueueIcon)
//        make.left.equalTo(addToQueueIcon.snp_right).offset(3)
//    }
    
    articleSeparatorBar.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.05)
    articleSeparatorBar.snp_makeConstraints { (make) -> Void in
        make.left.bottom.right.equalTo(articleCell)
        make.height.equalTo(1)
    }
    
    guard let fullURL = ArticleListArray[indexPath.row].url else {
        articleOrigin.text = "Not Found"
        return articleCell
    }
//    let fullURLArray = fullURL.characters.split{$0 == "."}.map(String.init)
//    articleOrigin.text = fullURLArray[1]
    articleIcon.image = UIImage(named: "parrot-load")
    downloadAndCacheImage(articleIcon, indexPath: indexPath)
    
    
    articleIcon.snp_makeConstraints { (make) -> Void in
        
        make.left.equalTo(articleTitle.snp_right).offset(10)
        make.top.equalTo(articleTitle.snp_top).offset(-5)
        make.height.width.equalTo(85)
    }
    articleIcon.layer.cornerRadius = articleIcon.frame.size.height/2
    articleIcon.clipsToBounds = true
    
    
    return articleCell
}

func generateArticleListRecordCell(tableView: UITableView,indexPath: NSIndexPath)->UITableViewCell {
    let articleCell = UITableViewCell(style: .Default, reuseIdentifier: "articleCell")
    let articleTitle = UILabel()
    let articleAbstract = UILabel()
    let articleSeparatorBar = UIView()
    let articleRating = UIImageView()
    let playCountImage = UIImageView()
    let playCount = UILabel()
    let shareCountImage = UIImageView()
    let shareCount = UILabel()
    let articleOrigin = UILabel()
    let articleIcon = UIImageView()
    let addToQueueIcon = UIImageView()
    let addToQueueLabel = UILabel()
    addToQueueIcon.hidden = true
    addToQueueLabel.hidden = true
    
    
    articleIcon.frame = CGRectMake(0, 0, 85, 85)
    
    articleCell.selectionStyle = .None
    articleCell.addSubview(articleTitle)
    articleCell.addSubview(articleAbstract)
    articleCell.addSubview(articleSeparatorBar)
    articleCell.addSubview(articleRating)
    articleCell.addSubview(playCountImage)
    articleCell.addSubview(playCount)
    articleCell.addSubview(shareCountImage)
    articleCell.addSubview(shareCount)
    articleCell.addSubview(articleOrigin)
    articleCell.addSubview(articleIcon)
    articleCell.addSubview(addToQueueIcon)
    articleCell.addSubview(addToQueueLabel)
    
    
    articleTitle.text = ArticleListArray[indexPath.row].title
    articleAbstract.text = ArticleListArray[indexPath.row].abstract
    
    articleTitle.font = articleListTileFont
    articleTitle.textColor = UIColor.blackColor()
    articleAbstract.font = articleListAbstractFont
    articleAbstract.textColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
    
    transformIntoJustified(articleTitle, lineSpace: 0)
    transformIntoJustified(articleAbstract, lineSpace: 0)
    
    articleRating.image = UIImage(named: "rating")
    playCountImage.image = UIImage(named: "playCount")
    shareCountImage.image = UIImage(named: "sharedCount")
    
    let numberFormatter = NSNumberFormatter()
    numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
    let unitedStatesLocale = NSLocale(localeIdentifier: "en_US")
    numberFormatter.locale = unitedStatesLocale
    
    playCount.text = numberFormatter.stringFromNumber(NSNumber(unsignedInt: arc4random_uniform(456789)))
    shareCount.text = numberFormatter.stringFromNumber(NSNumber(unsignedInt: arc4random_uniform(212356)))
    playCount.adjustsFontSizeToFitWidth = true
    shareCount.adjustsFontSizeToFitWidth = true
    articleOrigin.adjustsFontSizeToFitWidth = true
    
    articleTitle.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(articleCell.snp_left).offset(15)
        make.right.equalTo(articleCell.snp_right).offset(-100)
        make.top.equalTo(articleCell.snp_top).offset(25)
    }
    articleAbstract.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(articleTitle.snp_left)
        make.right.equalTo(articleTitle.snp_right)
        make.top.equalTo(articleTitle.snp_bottom).offset(5)
    }
    articleRating.hidden = true
    playCountImage.hidden = true
    playCount.hidden = true
    shareCountImage.hidden = true
    shareCount.hidden = true
    
    articleRating.snp_makeConstraints { (make) -> Void in
        //        make.width.equalTo(50)
        make.height.equalTo(10)
        make.left.equalTo(articleTitle.snp_left)
        make.top.equalTo(articleAbstract.snp_bottom).offset(15)
    }
    playCountImage.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(articleRating.snp_right).offset(10)
        make.width.height.equalTo(10)
        make.centerY.equalTo(articleRating.snp_centerY)
    }
    playCount.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(playCountImage.snp_right).offset(5)
        make.centerY.equalTo(playCountImage.snp_centerY)
        make.width.equalTo(40)
    }
    shareCountImage.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(playCount.snp_right).offset(20)
        make.width.height.equalTo(playCountImage.snp_width)
        make.centerY.equalTo(articleRating.snp_centerY)
    }
    shareCount.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(shareCountImage.snp_right).offset(5)
        make.centerY.equalTo(shareCountImage.snp_centerY)
        make.width.equalTo(40)
    }
    articleOrigin.textAlignment = .Right
    articleOrigin.textColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
//    articleOrigin.snp_makeConstraints { (make) -> Void in
//        make.centerY.equalTo(addToQueueLabel)
//        make.left.equalTo(shareCount.snp_right).offset(10)
//        make.right.equalTo(articleIcon.snp_left).offset(-4)
//        make.width.equalTo(40)
//    }
    articleOrigin.snp_makeConstraints { (make) -> Void in
        make.centerX.equalTo(articleIcon)
        make.top.equalTo(articleIcon.snp_bottom).offset(2)
        make.width.equalTo(40)
    }
//    if articleOrigin == "outloud" {
        articleOrigin.hidden = true
//    }1
    
    addToQueueIcon.image = UIImage(named: "notify")
    addToQueueIcon.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(articleTitle)
        make.height.width.equalTo(25)
        make.bottom.equalTo(articleSeparatorBar).offset(-10)
    }
    addToQueueLabel.text = "Get notified when Read"
    addToQueueLabel.font = addToQueueFont
    addToQueueLabel.textColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
    addToQueueLabel.snp_makeConstraints { (make) -> Void in
        make.centerY.equalTo(addToQueueIcon)
        make.left.equalTo(addToQueueIcon.snp_right).offset(3)
    }
    
    articleSeparatorBar.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.05)
    articleSeparatorBar.snp_makeConstraints { (make) -> Void in
        make.left.bottom.right.equalTo(articleCell)
        make.height.equalTo(1)
    }
    
    guard let fullURL = ArticleListArray[indexPath.row].url else {
        articleOrigin.text = "Not Found"
        return articleCell
    }
//    let fullURLArray = fullURL.characters.split{$0 == "."}.map(String.init)
//    articleOrigin.text = fullURLArray[1]
    
    articleIcon.image = UIImage(named: "parrot-load")
    downloadAndCacheImage(articleIcon, indexPath: indexPath)
    
    
    articleIcon.snp_makeConstraints { (make) -> Void in
        
        make.left.equalTo(articleTitle.snp_right).offset(10)
        make.top.equalTo(articleTitle.snp_top).offset(-5)
        make.height.width.equalTo(85)
    }
    articleIcon.layer.cornerRadius = articleIcon.frame.size.height/2
    articleIcon.clipsToBounds = true
    
    
    return articleCell
}