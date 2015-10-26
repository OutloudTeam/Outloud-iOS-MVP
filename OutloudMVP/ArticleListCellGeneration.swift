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

func generateArticleListCell(indexPath: NSIndexPath)->UITableViewCell {
    let articleCell = UITableViewCell()
    let articleTitle = UILabel()
    let articleAbstract = UILabel()
    let articleSeparatorBar = UIView()
    let articleRating = UIImageView()
    let playCountImage = UIImageView()
    let playCount = UILabel()
    let shareCountImage = UIImageView()
    let shareCount = UILabel()
    let articleOrigin = UILabel()
    
    articleCell.addSubview(articleTitle)
    articleCell.addSubview(articleAbstract)
    articleCell.addSubview(articleSeparatorBar)
    articleCell.addSubview(articleRating)
    articleCell.addSubview(playCountImage)
    articleCell.addSubview(playCount)
    articleCell.addSubview(shareCountImage)
    articleCell.addSubview(shareCount)
    articleCell.addSubview(articleOrigin)
    
    articleTitle.text = ArticleListArray[indexPath.row].title
    articleAbstract.text = ArticleListArray[indexPath.row].abstract
    


    let fontTest = UIFont(name: "Helvetica", size: 14.0)
    articleTitle.font = fontTest
    articleTitle.textColor = UIColor.redColor()
    articleAbstract.font = articleAbstractFont
    
    articleTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
    articleAbstract.lineBreakMode = NSLineBreakMode.ByWordWrapping
    
    articleTitle.numberOfLines = 0
    articleAbstract.numberOfLines = 0
    
    articleRating.image = UIImage(named: "rating")
    playCountImage.image = UIImage(named: "rating")
    shareCountImage.image = UIImage(named: "rating")
    
    playCount.text = "100,000"
    shareCount.text = "200,000"
    playCount.adjustsFontSizeToFitWidth = true
    shareCount.adjustsFontSizeToFitWidth = true
    articleOrigin.adjustsFontSizeToFitWidth = true
    
    articleTitle.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(articleCell.snp_left).offset(15)
        make.right.equalTo(articleCell.snp_right).offset(-30)
        make.top.equalTo(articleCell.snp_top).offset(25)
    }
    articleAbstract.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(articleTitle.snp_left)
        make.right.equalTo(articleTitle.snp_right)
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
        make.width.height.equalTo(15)
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