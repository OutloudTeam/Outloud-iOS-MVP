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
        let firstSlash = UILabel()
        let secondSlash = UILabel()
        superview.addSubview(topBar)
        superview.addSubview(articleBar)
        topBar.backgroundColor = topBarColor
        articleBar.backgroundColor = UIColor.blackColor()
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
        let outloudTopbarButton   = UIButton(type: UIButtonType.System) as UIButton
        outloudTopbarButton.frame = CGRectMake(50, 50, 50, 50)
        outloudTopbarButton.backgroundColor = topBarColor
        outloudTopbarButton.setTitle("Outloud", forState: UIControlState.Normal)
        outloudTopbarButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        outloudTopbarButton.titleLabel?.font = UIFont(name: ".SFUIText-Light", size: 18)
        topBar.addSubview(outloudTopbarButton)
        outloudTopbarButton.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(topBar)
            make.left.equalTo(topBar).offset(40)
        }
        firstSlash.text = "/"
        firstSlash.font = UIFont(name: ".SFUIText-Light", size: 20)
        topBar.addSubview(firstSlash)
        firstSlash.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(outloudTopbarButton)
            make.left.equalTo(outloudTopbarButton.snp_right).offset(5)
        }
        let listenRecordButton   = UIButton(type: UIButtonType.System) as UIButton
        listenRecordButton.frame = CGRectMake(50, 50, 50, 50)
        listenRecordButton.backgroundColor = topBarColor
        listenRecordButton.setTitle("Listen", forState: UIControlState.Normal)
        listenRecordButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        listenRecordButton.titleLabel?.font = UIFont(name: ".SFUIText-Light", size: 18)
        topBar.addSubview(listenRecordButton)
        listenRecordButton.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(topBar)
            make.left.equalTo(firstSlash).offset(15)
        }
        secondSlash.text = "/ Article Name"
        secondSlash.font = UIFont(name: ".SFUIText-Light", size: 20)
        topBar.addSubview(secondSlash)
        secondSlash.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(outloudTopbarButton)
            make.left.equalTo(listenRecordButton.snp_right).offset(5)
        }
    }
}

func buttonAction(sender:UIButton!)
{
    print("Button tapped")
}