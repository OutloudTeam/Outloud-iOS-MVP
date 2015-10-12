//
//  ArticleList.swift
//  OutloudMVP
//
//  Created by Frederik Lohner on 10/Oct/15.
//  Copyright © 2015 Outloud. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import AVFoundation

class ArticleList: UIViewController {
    @IBOutlet var superView: UIView!
    
    
    override func viewDidLoad() {
        let topBar = UIView()
        let articleBar = UIView()
        
        let firstSlash = UILabel()
        let secondSlash = UILabel()
        superView.addSubview(topBar)
        superView.addSubview(articleBar)
        
        topBar.backgroundColor = topBarColor
        articleBar.backgroundColor = UIColor.whiteColor()
        
        
        topBar.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.top.equalTo(superView).offset(20)
            make.left.equalTo(superView).offset(0)
            make.right.equalTo(superView).offset(0)
        }
        articleBar.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(75)
            make.top.equalTo(topBar.snp_bottom).offset(0)
            make.left.equalTo(superView).offset(0)
            make.right.equalTo(superView).offset(0)
        }
        
        //Declarations for topBar
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
        let outloudTopbarButton = UIButton(type: UIButtonType.System) as UIButton
        outloudTopbarButton.frame = CGRectMake(50, 50, 50, 50)
        outloudTopbarButton.backgroundColor = topBarColor
        outloudTopbarButton.setTitle("Outloud", forState: UIControlState.Normal)
        outloudTopbarButton.setTitleColor(transparentBlack, forState: .Normal)
        outloudTopbarButton.titleLabel?.font = UIFont(name: ".SFNSDisplay-Ultralight", size: 18)
        topBar.addSubview(outloudTopbarButton)
        outloudTopbarButton.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(backButton.snp_centerY)
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
    }
}