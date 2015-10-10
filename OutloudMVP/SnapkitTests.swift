//
//  SnapkitTests.swift
//  OutloudMVP
//
//  Created by Frederik Lohner on 10/Oct/15.
//  Copyright © 2015 Outloud. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class SnapkitTests: UIViewController {
    @IBOutlet var superview: UIView!
    
    override func viewDidLoad() {
        let topBar = UIView()
        let articleBar = UIView()
        let bottomBar = UIView()
        let middleView = UIView()
        let firstSlash = UILabel()
        let secondSlash = UILabel()

        
        superview.addSubview(topBar)
        superview.addSubview(articleBar)
        superview.addSubview(bottomBar)
        superview.addSubview(middleView)
        
        topBar.backgroundColor = topBarColor
        articleBar.backgroundColor = UIColor.whiteColor()
        middleView.backgroundColor = UIColor.blueColor()
        bottomBar.backgroundColor = darkRed
        
        topBar.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.top.equalTo(superview).offset(20)
            make.left.equalTo(superview).offset(0)
            make.right.equalTo(superview).offset(0)
        }
        articleBar.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(75)
            make.top.equalTo(topBar.snp_bottom).offset(0)
            make.left.equalTo(superview).offset(0)
            make.right.equalTo(superview).offset(0)
        }
        middleView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(articleBar.snp_bottom)
            make.bottom.equalTo(bottomBar.snp_top)
            make.left.equalTo(superview).offset(0)
            make.right.equalTo(superview).offset(0)
        }
        bottomBar.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(75)
            make.bottom.equalTo(superview).offset(0)
            make.left.equalTo(superview).offset(0)
            make.right.equalTo(superview).offset(0)
        }
        
        //Declarations for topBar
        let backButton = UIButton(type: UIButtonType.System) as UIButton
        backButton.backgroundColor = topBarColor
        backButton.setTitle("<", forState: UIControlState.Normal)
        backButton.setTitleColor(black, forState: .Normal)
        backButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 20)
        topBar.addSubview(backButton)
        backButton.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(topBar)
            make.left.equalTo(topBar).offset(10)
        }
        let outloudTopbarButton = UIButton(type: UIButtonType.System) as UIButton
        outloudTopbarButton.frame = CGRectMake(50, 50, 50, 50)
        outloudTopbarButton.backgroundColor = topBarColor
        outloudTopbarButton.setTitle("Outloud", forState: UIControlState.Normal)
        outloudTopbarButton.setTitleColor(transparentBlack, forState: .Normal)
        outloudTopbarButton.titleLabel?.font = UIFont(name: ".SFNSDisplay-Ultralight", size: 18)
        topBar.addSubview(outloudTopbarButton)
        outloudTopbarButton.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(topBar)
            make.left.equalTo(topBar).offset(40)
        }
        firstSlash.text = "/"
        firstSlash.font = UIFont(name: ".SFNSDisplay-Ultralight", size: 20)
        firstSlash.textColor = transparentBlack
        topBar.addSubview(firstSlash)
        firstSlash.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(outloudTopbarButton)
            make.left.equalTo(outloudTopbarButton.snp_right).offset(5)
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
            make.left.equalTo(firstSlash).offset(15)
        }
        secondSlash.text = "/"
        secondSlash.font = UIFont(name: ".SFNSDisplay-Ultralight", size: 20)
        secondSlash.textColor = transparentBlack
        topBar.addSubview(secondSlash)
        secondSlash.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(outloudTopbarButton)
            make.left.equalTo(listenRecordButton.snp_right).offset(5)
        }
        let articleNameButton = UIButton(type: UIButtonType.System) as UIButton
        articleNameButton.frame = CGRectMake(50, 50, 50, 50)
        articleNameButton.backgroundColor = topBarColor
        articleNameButton.setTitle("Article Name", forState: UIControlState.Normal)
        articleNameButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        articleNameButton.titleLabel?.font = UIFont(name: ".SFNSFUITextSDisplay-Ultralight", size: 18)
        articleNameButton.enabled = false
        topBar.addSubview(articleNameButton)
        articleNameButton.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(topBar)
            make.left.equalTo(secondSlash.snp_right).offset(5)
        }
    
        //Declarations for articleBar
        let articleTitle = UILabel()
        articleTitle.text = "Article One"
        articleTitle.font = UIFont(name: ".SFUIText-Light", size: 24)
        articleTitle.textColor = black
        articleBar.addSubview(articleTitle)
        articleTitle.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(articleBar).offset(10)
            make.top.equalTo(articleBar).offset(10)
        }
        let articleLink = UILabel()
        articleLink.text = "nytimes.com/articleone"
        articleLink.textColor = transparentBlack
        articleLink.font = UIFont(name: ".SFUIText-Light", size: 12)
        articleBar.addSubview(articleLink)
        articleLink.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(articleTitle.snp_left)
            make.top.equalTo(articleTitle.snp_bottom).offset(2)
        }
        //Author stuff
        let authorName = UILabel()
        authorName.adjustsFontSizeToFitWidth = true
        authorName.text = "Vahid Mazdeh"
        authorName.font = UIFont(name: ".SFUIText-Light", size: 16)
        articleBar.addSubview(authorName)
        authorName.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(articleBar.snp_rightMargin)
            make.top.equalTo(articleBar).offset(8)
        }
        let authorLabel = UILabel()
        authorLabel.text = "author"
        authorLabel.font = UIFont(name: ".SFUIText-Light", size: 16)
        authorLabel.textColor = transparentBlack
        articleBar.addSubview(authorLabel)
        authorLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(articleBar.snp_rightMargin).offset(-180)
            make.leading.equalTo(authorName).offset(-80)
            make.top.equalTo(authorName)
        }
        let authorRatingBar = UIView()
        authorRatingBar.backgroundColor = UIColor.redColor()
        articleBar.addSubview(authorRatingBar)
        authorRatingBar.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(3)
            make.top.equalTo(authorName.snp_bottom).offset(5)
            make.left.equalTo(authorLabel.snp_left)
            make.right.equalTo(authorName.snp_right)
        }
        //Voice stuff
        let voiceName = UILabel()
        voiceName.adjustsFontSizeToFitWidth = true
        voiceName.text = "Fred Lohner"
        voiceName.font = UIFont(name: ".SFUIText-Light", size: 16)
        articleBar.addSubview(voiceName)
        voiceName.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(articleBar.snp_rightMargin)
            make.top.equalTo(authorRatingBar.snp_bottom).offset(3)
        }
        let voiceLabel = UILabel()
        voiceLabel.text = "voice"
        voiceLabel.font = UIFont(name: ".SFUIText-Light", size: 16)
        voiceLabel.textColor = transparentBlack
        articleBar.addSubview(voiceLabel)
        voiceLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(articleBar.snp_rightMargin).offset(-180)
            make.leading.equalTo(voiceName).offset(-80)
            make.top.equalTo(voiceName)
        }
        let voiceRatingBar = UIView()
        voiceRatingBar.backgroundColor = UIColor.redColor()
        articleBar.addSubview(voiceRatingBar)
        voiceRatingBar.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(3)
            make.top.equalTo(voiceName.snp_bottom).offset(5)
            make.left.equalTo(authorRatingBar.snp_left)
            make.right.equalTo(voiceName.snp_right)
        }

        
        
    
    
    
    }
}

func buttonAction(sender:UIButton!)
{
    print("Button tapped")
}