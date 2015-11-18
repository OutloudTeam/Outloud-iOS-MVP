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


// MARK: - Generates Navigation Top Bar for Article Detail
func createNavigationTitleViewArticleRecordParagraph(title: String, callback: ()->Void) -> UIView {
    let container = UIButton()
    let titleLabel = UILabel()
    
    
    container.frame = CGRect(x: 0, y: 0, width: 300, height: 32)
    container.addSubview(titleLabel)
    
    
    titleLabel.text = title
    titleLabel.font = recordArticleTitleFont
    titleLabel.textColor = barTextColor
    titleLabel.textAlignment = .Left
    
    titleLabel.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(container.snp_left)
        make.centerY.equalTo(container.snp_centerY)
    }
    
    return container
}

// MARK: - Generates Navigation Top Bar for Article List Listen
func createNavigationTitleViewArticleListListen(listenContainer: UIButton, title: String, category: String, callback: ()->Void) -> UIView {
    
    let topFrame = UIView()
    let categoryContainer = UIButton()
    let listenRecordLabel = UILabel()
    let listenRecordImageView = UIImageView()
    let separatorLabel = UILabel()
    let subtitleLabel = UILabel()
    let subtitleImageView = UIImageView()
    
    
    
    topFrame.addSubview(listenContainer)
    topFrame.addSubview(categoryContainer)
    topFrame.frame = CGRect(x: 0, y: 0, width: 200, height: 32)
    
    listenContainer.frame = CGRect(x: 0, y: 0, width: 100, height: 32)
    listenContainer.addSubview(listenRecordLabel)
    listenContainer.addSubview(listenRecordImageView)
    
    categoryContainer.frame = CGRect(x: 0, y: 0, width: 100, height: 32)
    categoryContainer.addSubview(subtitleLabel)
    categoryContainer.addSubview(subtitleImageView)
    
    topFrame.addSubview(separatorLabel)
    
    listenRecordLabel.text = title
    listenRecordLabel.font = ListenRecordFont
    listenRecordLabel.textColor = yellowColor
    listenRecordLabel.textAlignment = .Center
    
    subtitleLabel.text = category
    subtitleLabel.font = CategoryTopBarFont
    subtitleLabel.textColor = blackColor.colorWithAlphaComponent(0.3)
    subtitleLabel.textAlignment = .Center
    
    separatorLabel.text = "|"
    separatorLabel.font = separatorTitleFont
    separatorLabel.textColor = blackColor.colorWithAlphaComponent(0.1)
    separatorLabel.textAlignment = .Center
    
    separatorLabel.snp_makeConstraints { (make) -> Void in
        make.centerX.equalTo(topFrame)
        make.centerY.equalTo(topFrame).offset(5)
    }
    listenContainer.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(topFrame)
        make.right.equalTo(separatorLabel.snp_left)
        make.centerY.equalTo(topFrame)
        make.top.bottom.equalTo(topFrame)
    }
    listenRecordLabel.snp_makeConstraints { (make) -> Void in
        make.centerX.equalTo(listenContainer.snp_centerX)
        make.centerY.equalTo(listenContainer).offset(5)
    }
    listenRecordImageView.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(listenRecordLabel.snp_right).offset(5)
        make.height.width.equalTo(35)
        make.centerY.equalTo(listenRecordLabel)
    }
    
    
    categoryContainer.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(separatorLabel.snp_right).offset(3)
        make.right.equalTo(topFrame)
        make.centerY.equalTo(topFrame)
        make.top.bottom.equalTo(topFrame)
        
    }
    subtitleLabel.snp_makeConstraints { (make) -> Void in
        make.right.equalTo(categoryContainer.snp_centerX)
        make.centerY.equalTo(categoryContainer).offset(5)
    }
    
    subtitleImageView.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(subtitleLabel.snp_right).offset(5)
        make.height.width.equalTo(35)
        make.centerY.equalTo(subtitleLabel)
    }
    
    listenRecordImageView.image = UIImage(named: "downArrow")
    subtitleImageView.image = UIImage(named: "downArrow")
    listenRecordImageView.contentMode = .ScaleAspectFit
    subtitleImageView.contentMode = .ScaleAspectFit
    
    return topFrame
}

// MARK: - Generates Navigation Top Bar for Article List Record
func createNavigationTitleViewArticleListRecord(listenContainer: UIButton, title: String, category: String, callback: ()->Void) -> UIView {
    
    let topFrame = UIView()
    let categoryContainer = UIButton()
    let listenRecordLabel = UILabel()
    let listenRecordImageView = UIImageView()
    let separatorLabel = UILabel()
    let subtitleLabel = UILabel()
    let subtitleImageView = UIImageView()
    
    topFrame.addSubview(listenContainer)
    topFrame.addSubview(categoryContainer)
    topFrame.frame = CGRect(x: 0, y: 0, width: 200, height: 32)
    
    listenContainer.frame = CGRect(x: 0, y: 0, width: 100, height: 32)
    listenContainer.addSubview(listenRecordLabel)
    listenContainer.addSubview(listenRecordImageView)
    
    categoryContainer.frame = CGRect(x: 0, y: 0, width: 100, height: 32)
    categoryContainer.addSubview(subtitleLabel)
    categoryContainer.addSubview(subtitleImageView)
    
    topFrame.addSubview(separatorLabel)
    
    listenRecordLabel.text = title
    listenRecordLabel.font = ListenRecordFont
    listenRecordLabel.textColor = redColor
    listenRecordLabel.textAlignment = .Center
    
    subtitleLabel.text = category
    subtitleLabel.font = CategoryTopBarFont
    subtitleLabel.textColor = blackColor.colorWithAlphaComponent(0.3)
    subtitleLabel.textAlignment = .Center
    
    separatorLabel.text = "|"
    separatorLabel.font = separatorTitleFont
    separatorLabel.textColor = blackColor.colorWithAlphaComponent(0.1)
    separatorLabel.textAlignment = .Center
    
    separatorLabel.snp_makeConstraints { (make) -> Void in
        make.centerX.equalTo(topFrame)
        make.centerY.equalTo(topFrame).offset(5)
    }
    listenContainer.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(topFrame)
        make.right.equalTo(separatorLabel.snp_left)
        make.centerY.equalTo(topFrame)
        make.top.bottom.equalTo(topFrame)
    }
    listenRecordLabel.snp_makeConstraints { (make) -> Void in
        make.centerX.equalTo(listenContainer.snp_centerX)
        make.centerY.equalTo(listenContainer).offset(5)
    }
    listenRecordImageView.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(listenRecordLabel.snp_right).offset(5)
        make.height.width.equalTo(35)
        make.centerY.equalTo(listenRecordLabel)
    }
    
    
    categoryContainer.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(separatorLabel.snp_right).offset(3)
        make.right.equalTo(topFrame)
        make.centerY.equalTo(topFrame)
        make.top.bottom.equalTo(topFrame)
        
    }
    subtitleLabel.snp_makeConstraints { (make) -> Void in
        make.right.equalTo(categoryContainer.snp_centerX)
        make.centerY.equalTo(categoryContainer).offset(5)
    }
    
    subtitleImageView.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(subtitleLabel.snp_right).offset(5)
        make.height.width.equalTo(35)
        make.centerY.equalTo(subtitleLabel)
    }
    
    listenRecordImageView.image = UIImage(named: "downArrow")
    subtitleImageView.image = UIImage(named: "downArrow")
    listenRecordImageView.contentMode = .ScaleAspectFit
    subtitleImageView.contentMode = .ScaleAspectFit
    
    return topFrame
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
    titleLabel.textColor = UIColor.blackColor()
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
    let separatorBar = UIView()
    bottomBar.addSubview(separatorBar)
    separatorBar.backgroundColor = yellowColor
    separatorBar.snp_makeConstraints { (make) -> Void in
        make.top.left.right.equalTo(bottomBar)
        make.height.equalTo(0.5)
    }
    superView.addSubview(bottomBar)
    bottomBar.backgroundColor = UIColor.whiteColor()
    
    
    bottomBar.snp_makeConstraints { (make) -> Void in
        make.height.equalTo(60)
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
    let separatorBar = UIView()
    let recordInstructions = UILabel()
    superView.addSubview(bottomBar)
    superView.addSubview(recordInstructions)
    superView.addSubview(separatorBar)
    
    bottomBar.backgroundColor = barColor
    separatorBar.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.15)
    recordInstructions.text = "Hold a paragraph to start recording!"
    recordInstructions.font = mediumTitleFont
    recordInstructions.textColor = UIColor.redColor()
    
    bottomBar.snp_makeConstraints { (make) -> Void in
        make.height.equalTo(30)
        make.bottom.equalTo(superView).offset(0)
        make.left.equalTo(superView).offset(0)
        make.right.equalTo(superView).offset(0)
    }
    recordInstructions.snp_makeConstraints { (make) -> Void in
        make.centerX.equalTo(bottomBar.snp_centerX)
        make.centerY.equalTo(bottomBar.snp_centerY)
    }
    separatorBar.snp_makeConstraints { (make) -> Void in
        make.left.top.right.equalTo(bottomBar)
        make.height.equalTo(0.5)
    }
    return bottomBar
}


/*
MARK: - Generates bottom article list bar
With QueueList button, queue instructions, playQueueButton and playQueueInstructions.
*/
func createBottomArticleListBar(view: UIView, playButton: UIButton)->UIView{
    let bottomBar = UIView()
    let separatorBar = UIView()
    bottomBar.addSubview(separatorBar)
    separatorBar.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
    separatorBar.snp_makeConstraints { (make) -> Void in
        make.top.left.right.equalTo(bottomBar)
        make.height.equalTo(0.5)
    }
    view.addSubview(bottomBar)
    bottomBar.backgroundColor = barColor
    bottomBar.snp_makeConstraints { (make) -> Void in
        make.height.equalTo(50)
        make.bottom.equalTo(view).offset(0)
        make.left.equalTo(view).offset(0)
        make.right.equalTo(view).offset(0)
    }
    
    let queueListButton = UIButton(type: UIButtonType.System) as UIButton
    queueListButton.setBackgroundImage(UIImage(named: "edit-queue"), forState: .Normal)
    bottomBar.addSubview(queueListButton)
    queueListButton.snp_makeConstraints { (make) -> Void in
        make.height.width.equalTo(25)
        make.left.equalTo(bottomBar.snp_left).offset(10)
        make.centerY.equalTo(bottomBar.snp_centerY)
    }
    
    playButton.setBackgroundImage(UIImage(named: "playCount"), forState: .Normal)
    bottomBar.addSubview(playButton)
    //    queueButton.backgroundColor = UIColor.whiteColor()
    playButton.snp_makeConstraints { (make) -> Void in
        make.height.width.equalTo(30)
        make.centerY.centerX.equalTo(bottomBar)
    }
    playButton.contentMode = .ScaleAspectFit
    let playQueueInstructions = UILabel()
    playQueueInstructions.text = "3 in queue"
    playQueueInstructions.textAlignment = .Right
    playQueueInstructions.font = UIFont(name: "Helvetica-Light", size: 12)
    playQueueInstructions.textColor = UIColor(red:0.72, green:0.72, blue:0.72, alpha:1.0)
    playQueueInstructions.adjustsFontSizeToFitWidth = true
    bottomBar.addSubview(playQueueInstructions)
    
    playQueueInstructions.snp_makeConstraints { (make) -> Void in
        make.right.equalTo(bottomBar).offset(-10)
        make.centerY.equalTo(queueListButton.snp_centerY)
    }
    return bottomBar
}
/*
MARK: - Generates bottom bar for recording paragraphs
*/
func createBottomParagraphRecordingBar(superView: UIView)->UIView{
    let bottomBar = UIView()
    let separatorBar = UIView()
    superView.addSubview(bottomBar)
    superView.addSubview(separatorBar)
    
    bottomBar.backgroundColor = barColor
    separatorBar.backgroundColor = redColor
    
    separatorBar.snp_makeConstraints { (make) -> Void in
        make.left.top.right.equalTo(bottomBar)
        make.height.equalTo(0.5)
    }
    bottomBar.snp_makeConstraints { (make) -> Void in
        make.height.equalTo(60)
        make.bottom.equalTo(superView).offset(0)
        make.left.equalTo(superView).offset(0)
        make.right.equalTo(superView).offset(0)
    }
    return bottomBar
}
