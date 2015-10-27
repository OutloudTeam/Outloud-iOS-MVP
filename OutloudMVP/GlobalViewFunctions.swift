//
//  GlobalViewFunctions.swift
//  OutloudMVP
//
//  Created by Frederik Lohner on 14/Oct/15.
//  Copyright © 2015 Outloud. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

// MARK: - Generates Navigation Top Bar for Article List
func createNavigationTitleViewArticleList(title: String, callback: ()->Void) -> UIView {
    let container = UIButton()
    let titleLabel = UILabel()
    let imageView = UIImageView()
    let separatorLabel = UILabel()
    let subtitleLabel = UILabel()
    let subtitleImageView = UIImageView()
    
    
    container.frame = CGRect(x: 0, y: 0, width: 180, height: 32)
    container.addSubview(titleLabel)
    container.addSubview(imageView)
    container.addSubview(subtitleLabel)
    container.addSubview(subtitleImageView)
    container.addSubview(separatorLabel)
    
    titleLabel.text = title
    titleLabel.font = largeTitleFont
    titleLabel.textColor = UIColor.whiteColor()
    titleLabel.textAlignment = .Center
    
    subtitleLabel.text = "Popular"
    subtitleLabel.font = largeTitleFont
    subtitleLabel.textColor = UIColor.whiteColor()
    subtitleLabel.textAlignment = .Center
    
    separatorLabel.text = "/"
    separatorLabel.font = separatorTitleFont
    separatorLabel.textColor = UIColor.whiteColor()
    separatorLabel.textAlignment = .Center

    
    titleLabel.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(container.snp_left)
        make.centerY.equalTo(container.snp_centerY)
    }
    
    imageView.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(titleLabel.snp_right).offset(5)
        make.height.width.equalTo(16)
        make.centerY.equalTo(container.snp_centerY)
    }
    separatorLabel.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(imageView.snp_right).offset(5)
        make.centerY.equalTo(container.snp_centerY)
    }
    subtitleLabel.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(separatorLabel.snp_right).offset(5)
        make.centerY.equalTo(container.snp_centerY)
    }
    
    subtitleImageView.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(subtitleLabel.snp_right).offset(5)
        make.height.width.equalTo(16)
        make.centerY.equalTo(container.snp_centerY)
    }
    
    imageView.image = UIImage(named: "downArrow")
    subtitleImageView.image = UIImage(named: "downArrow")
    imageView.contentMode = .ScaleAspectFit
    subtitleImageView.contentMode = .ScaleAspectFit
    
    return container
}
// MARK: - Generates Navigation Top Bar for Article Detail
func createNavigationTitleViewArticleDetail(title: String, callback: ()->Void) -> UIView {
    let container = UIButton()
    let titleLabel = UILabel()
    let imageView = UIImageView()
    
    
    container.frame = CGRect(x: 0, y: 0, width: 128, height: 32)
    container.addSubview(titleLabel)
    container.addSubview(imageView)

    
    titleLabel.text = title
    titleLabel.font = largeTitleFont
    titleLabel.textColor = UIColor.whiteColor()
    titleLabel.textAlignment = .Center
    
    titleLabel.snp_makeConstraints { (make) -> Void in
//        make.left.equalTo(container.snp_left)
        make.center.equalTo(container.snp_center)
    }
    
    imageView.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(titleLabel.snp_right).offset(5)
        make.height.width.equalTo(16)
        make.centerY.equalTo(container.snp_centerY)
    }
    
    imageView.image = UIImage(named: "downArrow")
    imageView.contentMode = .ScaleAspectFit
    
    return container
}

// MARK: - Generates Top Bar, now deprecated
func createTopBar(superView: UIView)->UIView {
    let topBar = UIView()
    superView.addSubview(topBar)
    topBar.backgroundColor = topBarColor
    topBar.snp_makeConstraints { (make) -> Void in
        make.height.equalTo(30)
        make.top.equalTo(superView.snp_top)
        make.left.equalTo(superView).offset(0)
        make.right.equalTo(superView).offset(0)
    }
    let backButton = UIButton(type: UIButtonType.System) as UIButton
    backButton.backgroundColor = topBarColor
    backButton.setTitle("<", forState: UIControlState.Normal)
    backButton.setTitleColor(black, forState: .Normal)
    backButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 20)
    topBar.addSubview(backButton)
    backButton.snp_makeConstraints { (make) -> Void in
        make.centerY.equalTo(topBar.snp_centerY)
        make.left.equalTo(topBar).offset(10)
    }
    let listenRecordButton   = UIButton(type: UIButtonType.System) as UIButton
    listenRecordButton.frame = CGRectMake(50, 50, 50, 50)
    listenRecordButton.backgroundColor = topBarColor
    listenRecordButton.setTitle("Listen", forState: UIControlState.Normal)
    listenRecordButton.setTitleColor(transparentBlack, forState: .Normal)
    listenRecordButton.titleLabel?.font = UIFont(name: ".SFNSDisplay-Ultralight", size: 18)
    topBar.addSubview(listenRecordButton)
    listenRecordButton.snp_makeConstraints { (make) -> Void in
        make.centerY.equalTo(topBar)
        make.centerX.equalTo(topBar)
    }
    let downArrowButton = UIButton(type: UIButtonType.System) as UIButton
    downArrowButton.frame = CGRectMake(50, 50, 50, 50)
    downArrowButton.setBackgroundImage(UIImage(named: "play-button"), forState: .Normal)
    downArrowButton.backgroundColor = topBarColor
    downArrowButton.enabled = false
    topBar.addSubview(downArrowButton)
    downArrowButton.snp_makeConstraints { (make) -> Void in
        make.centerY.equalTo(topBar)
        make.left.equalTo(listenRecordButton.snp_right).offset(5)
    }
    return topBar
}

//MARK: - Creates Title Author bar, now deprecated
func createTitleAuthorBarListen(superView: UIView)->UIView {
    let articleBar = UIView()
    superView.addSubview(articleBar)
    articleBar.backgroundColor = UIColor.whiteColor()
    articleBar.snp_makeConstraints { (make) -> Void in
        make.height.equalTo(75)
        make.top.equalTo(50)
        make.left.equalTo(superView).offset(0)
        make.right.equalTo(superView).offset(0)
    }
    let articleTitle = UILabel()
    articleTitle.text = "Article One"
    articleTitle.font = UIFont(name: ".SFUIText-Light", size: 24)
    articleTitle.textColor = black
    articleBar.addSubview(articleTitle)
    articleTitle.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(articleBar).offset(30)
        make.top.equalTo(articleBar).offset(5)
    }
    let separatorBar = UIView()
    articleBar.addSubview(separatorBar)
    separatorBar.backgroundColor = UIColor.greenColor()
    separatorBar.snp_makeConstraints { (make) -> Void in
        make.height.equalTo(1)
        make.top.equalTo(articleTitle.snp_bottom)
        make.left.equalTo(articleBar.snp_left).offset(30)
        make.right.equalTo(articleBar.snp_right).offset(-30)
    }
    let authorName = UILabel()
    authorName.adjustsFontSizeToFitWidth = true
    authorName.text = "Vahid Mazdeh"
    authorName.font = UIFont(name: ".SFUIText-Light", size: 10)
    articleBar.addSubview(authorName)
    authorName.snp_makeConstraints { (make) -> Void in
        make.top.equalTo(separatorBar.snp_bottom)
        make.left.equalTo(separatorBar.snp_left)
    }
    let articleLink = UILabel()
    articleLink.text = "nytimes.com/articleone"
    articleLink.textColor = transparentBlack
    articleLink.font = UIFont(name: ".SFUIText-Light", size: 10)
    articleBar.addSubview(articleLink)
    articleLink.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(authorName.snp_left)
        make.top.equalTo(authorName.snp_bottom).offset(2)
    }
    let voiceName = UILabel()
    voiceName.adjustsFontSizeToFitWidth = true
    voiceName.text = "@FredLohner"
    voiceName.font = UIFont(name: ".SFUIText-Light", size: 12)
    articleBar.addSubview(voiceName)
    voiceName.snp_makeConstraints { (make) -> Void in
        make.right.equalTo(separatorBar.snp_rightMargin)
        make.top.equalTo(authorName.snp_top)
    }
    return articleBar
}

/*
MARK: - Generates bottom article detail bar
*/
func createBottomArticleDetailBar(superView: UIView)->UIView{
    let bottomBar = UIView()
    superView.addSubview(bottomBar)
    bottomBar.backgroundColor = UIColor(red:0.07, green:0.09, blue:0.16, alpha:1.0)
    
    
    bottomBar.snp_makeConstraints { (make) -> Void in
        make.height.equalTo(75)
        make.bottom.equalTo(superView).offset(0)
        make.left.equalTo(superView).offset(0)
        make.right.equalTo(superView).offset(0)
    }
    return bottomBar
}

/*
MARK: - Generates bottom record detail bar
*/
func createBottomRecordDetailBar(superView: UIView)->UIView{
    let bottomBar = UIView()
    superView.addSubview(bottomBar)
    bottomBar.backgroundColor = UIColor(red:0.07, green:0.09, blue:0.16, alpha:1.0)
    
    
    bottomBar.snp_makeConstraints { (make) -> Void in
        make.height.equalTo(75)
        make.bottom.equalTo(superView).offset(0)
        make.left.equalTo(superView).offset(0)
        make.right.equalTo(superView).offset(0)
    }
    return bottomBar
}


/*
MARK: - Generates bottom article list bar
With QueueList button, queue instructions, playQueueButton and playQueueInstructions.
*/
func createBottomArticleListBar(view: UIView)->UIView{
    let bottomBar = UIView()
    view.addSubview(bottomBar)
    bottomBar.backgroundColor = UIColor(red:0.07, green:0.09, blue:0.16, alpha:1.0)
    bottomBar.snp_makeConstraints { (make) -> Void in
        make.height.equalTo(40)
        make.bottom.equalTo(view).offset(0)
        make.left.equalTo(view).offset(0)
        make.right.equalTo(view).offset(0)
    }
    
    let queueListButton = UIButton(type: UIButtonType.System) as UIButton
    queueListButton.setBackgroundImage(UIImage(named: "edit-queue"), forState: .Normal)
    bottomBar.addSubview(queueListButton)
    queueListButton.snp_makeConstraints { (make) -> Void in
        make.height.width.equalTo(33)
        make.left.equalTo(bottomBar.snp_left).offset(10)
        make.centerY.equalTo(bottomBar.snp_centerY)
    }
    
    let queueInstructions = UILabel()
    queueInstructions.text = "Edit Queue"
    queueInstructions.font = UIFont(name: "Helvetica-Light", size: 12)
    queueInstructions.textColor = UIColor(red:0.72, green:0.72, blue:0.72, alpha:0.3)
    queueInstructions.adjustsFontSizeToFitWidth = true
    bottomBar.addSubview(queueInstructions)
    
    queueInstructions.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(queueListButton.snp_right).offset(5)
        make.centerY.equalTo(queueListButton.snp_centerY)
        make.width.equalTo(75)
    }
    
    let playQueueButton = UIButton(type: UIButtonType.System) as UIButton
    playQueueButton.setBackgroundImage(UIImage(named: "play-button"), forState: .Normal)
    bottomBar.addSubview(playQueueButton)
    //    queueButton.backgroundColor = UIColor.whiteColor()
    playQueueButton.snp_makeConstraints { (make) -> Void in
        make.height.width.equalTo(33)
        make.right.equalTo(bottomBar.snp_right).offset(-5)
        make.centerY.equalTo(bottomBar.snp_centerY)
    }
    playQueueButton.contentMode = .ScaleAspectFit
    let playQueueInstructions = UILabel()
    playQueueInstructions.text = "3 items in your queue"
    playQueueInstructions.textAlignment = .Right
    playQueueInstructions.font = UIFont(name: "Helvetica-Light", size: 12)
    playQueueInstructions.textColor = UIColor(red:0.72, green:0.72, blue:0.72, alpha:1.0)
    playQueueInstructions.adjustsFontSizeToFitWidth = true
    bottomBar.addSubview(playQueueInstructions)
    
    playQueueInstructions.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(queueInstructions.snp_right)
        make.right.equalTo(playQueueButton.snp_left).offset(-5)
        make.centerY.equalTo(queueListButton.snp_centerY)
    }
    return bottomBar
}