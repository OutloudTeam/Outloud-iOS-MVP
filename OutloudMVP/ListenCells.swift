//
//  ArticleHeader.swift
//  OutloudMVP
//
//  Created by Frederik Lohner on 14/Oct/15.
//  Copyright © 2015 Outloud. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
class ArticleHeader: UITableViewCell {

}

class ListenCell: UITableViewCell {
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
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    func commonInit() {
        addSubview(articleTitle)
        addSubview(articleAbstract)
        addSubview(articleSeparatorBar)
        addSubview(articleRating)
        addSubview(playCountImage)
        addSubview(playCount)
        addSubview(shareCountImage)
        addSubview(shareCount)
        addSubview(articleOrigin)
        addSubview(articleIcon)
        
        selectionStyle = .None

        articleIcon.frame = CGRectMake(0, 0, 85, 85)
        // apply frames, constraints etc
        articleTitle.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.snp_left).offset(15)
            make.right.equalTo(self.snp_right).offset(-100)
            make.top.equalTo(self.snp_top).offset(25)
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
        
        articleSeparatorBar.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.05)
        articleSeparatorBar.snp_makeConstraints { (make) -> Void in
            make.left.bottom.right.equalTo(self)
            make.height.equalTo(1)
        }
        
        articleIcon.image = UIImage(named: "parrot-load")

        
        articleIcon.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(articleTitle.snp_right).offset(10)
            make.top.equalTo(articleTitle.snp_top).offset(-5)
            make.height.width.equalTo(85)
        }

    }
}