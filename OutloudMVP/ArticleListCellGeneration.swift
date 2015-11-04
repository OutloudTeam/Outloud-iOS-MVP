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
    let articleIcon = UIImageView()
    
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
        make.width.equalTo(50)
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
        make.centerY.equalTo(articleRating.snp_centerY)
        make.left.equalTo(shareCount.snp_right).offset(10)
        make.right.equalTo(articleIcon.snp_left).offset(-4)
        make.width.equalTo(40)
    }
    
    
    articleSeparatorBar.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.05)
    articleSeparatorBar.snp_makeConstraints { (make) -> Void in
        make.left.right.equalTo(articleCell)
        make.height.equalTo(1)
        make.top.equalTo(articleRating.snp_bottom).offset(20)
    }
    
    guard let fullURL = ArticleListArray[indexPath.row].url else {
        articleOrigin.text = "Not Found"
        return articleCell
    }
    let fullURLArray = fullURL.characters.split{$0 == "."}.map(String.init)
    articleOrigin.text = fullURLArray[1]
    
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