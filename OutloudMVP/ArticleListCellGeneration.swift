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

func generateArticleListCell(tableView: UITableView,indexPath: NSIndexPath)->UITableViewCell {
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
    let timeEstimate = UILabel()
    let addQueueButton = UIButton()
    
    articleCell.addSubview(articleTitle)
    articleCell.addSubview(articleAbstract)
    articleCell.addSubview(articleSeparatorBar)
    articleCell.addSubview(articleRating)
    articleCell.addSubview(playCountImage)
    articleCell.addSubview(playCount)
    articleCell.addSubview(shareCountImage)
    articleCell.addSubview(shareCount)
    articleCell.addSubview(articleOrigin)
    articleCell.addSubview(timeEstimate)
    articleCell.addSubview(addQueueButton)
    
    articleTitle.text = ArticleListArray[indexPath.row].title
    articleAbstract.text = ArticleListArray[indexPath.row].abstract
    var time = "5"
    let randomVar = arc4random_uniform(10)
    if(randomVar < 4) {
        time = "4"
    } else {
        time = String(randomVar)
    }
    timeEstimate.text = "\(time) min"
    


    let fontTest = UIFont(name: "Helvetica", size: 14.0)
    articleTitle.font = fontTest
    articleTitle.textColor = UIColor.redColor()
    articleAbstract.font = articleAbstractFont
    
    articleTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
    articleAbstract.lineBreakMode = NSLineBreakMode.ByWordWrapping
    
    articleTitle.numberOfLines = 0
    articleAbstract.numberOfLines = 0
    
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
    timeEstimate.adjustsFontSizeToFitWidth = true
    
    addQueueButton.frame = CGRectMake(50, 50, 50, 50)
    addQueueButton.setBackgroundImage(UIImage(named: "plus"), forState: .Normal)
    addQueueButton.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
    
    articleTitle.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(articleCell.snp_left).offset(15)
        make.right.equalTo(articleCell.snp_right).offset(-60)
        make.top.equalTo(articleCell.snp_top).offset(25)
    }
    articleAbstract.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(articleTitle.snp_left)
        make.right.equalTo(articleCell.snp_right).offset(-30)
        make.top.equalTo(articleTitle.snp_bottom).offset(3)
    }
    articleRating.snp_makeConstraints { (make) -> Void in
        make.width.equalTo(50)
        make.height.equalTo(10)
        make.left.equalTo(articleTitle.snp_left)
        make.top.equalTo(articleAbstract.snp_bottom).offset(5)
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
    articleOrigin.snp_makeConstraints { (make) -> Void in
        make.centerY.equalTo(articleRating.snp_centerY)
        make.left.equalTo(shareCount.snp_right).offset(10)
        make.width.equalTo(40)
    }
    addQueueButton.snp_makeConstraints { (make) -> Void in
        make.right.equalTo(articleCell.snp_right).offset(-5)
        make.height.width.equalTo(22)
        make.centerY.equalTo(timeEstimate.snp_centerY)
    }
    timeEstimate.snp_makeConstraints { (make) -> Void in
        make.top.equalTo(articleTitle.snp_top)
//        make.left.equalTo(articleTitle.snp_right).offset(-5)
        make.right.equalTo(addQueueButton.snp_left).offset(-5)
        make.width.equalTo(40)
    }
    
    
    articleSeparatorBar.backgroundColor = UIColor.blackColor()
    articleSeparatorBar.snp_makeConstraints { (make) -> Void in
        make.centerX.equalTo(articleCell.snp_centerX)
        make.left.equalTo(articleCell.snp_left).offset(30)
        make.right.equalTo(articleCell.snp_right).offset(-30)
        make.height.equalTo(1)
        make.bottom.equalTo(articleCell.snp_bottom).offset(2)
    }
    
    guard let fullURL = ArticleListArray[indexPath.row].url else {
        articleOrigin.text = "Not Found"
        return articleCell
    }
    let fullURLArray = fullURL.characters.split{$0 == "."}.map(String.init)
    articleOrigin.text = fullURLArray[1]

    
    return articleCell
}