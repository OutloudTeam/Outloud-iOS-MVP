//
//  CustomWebView.swift
//  OutloudMVP
//
//  Created by Frederik Lohner on 18/Nov/15.
//  Copyright © 2015 Outloud. All rights reserved.
//


import UIKit
import SnapKit
import AVFoundation
import Foundation

class CustomRecordWebView: UIViewController {
    let webView = UIWebView()
    let backgroundView = UIView()
    let initialURL = "http://google.com"
    
    var recordButton : RecordButton!
    var checkButton : UIButton!
    var playbackButton : UIButton!
    let backwardButton = UIButton(type: UIButtonType.System) as UIButton
    let forwardButton = UIButton(type: UIButtonType.System) as UIButton
    let trashButton = UIButton(type: UIButtonType.System) as UIButton

    var timeLabel : UILabel!
    var timer : NSTimer!
    var playerTimer : NSTimer!
    var audioFiles : NSMutableArray!
    

    
    override func viewDidLoad() {
        self.view.addSubview(webView)
        let bottomBar = createBottomParagraphRecordingBar(self.view)
        webView.snp_makeConstraints { (make) -> Void in
            make.left.right.top.equalTo(self.view)
            make.bottom.equalTo(bottomBar.snp_top)
        }
        loadAddressURL()
        
        //Bottom bar buttons
        recordButton = RecordButton()//UIButton(type: UIButtonType.System) as UIButton
        checkButton = UIButton(type: UIButtonType.System) as UIButton
        checkButton.hidden = true        
        
        forwardButton.frame = CGRectMake(50, 50, 70, 50)
        recordButton.frame = CGRectMake(100,100,100,100)
        bottomBar.addSubview(backwardButton)
        bottomBar.addSubview(forwardButton)
        bottomBar.addSubview(recordButton)
        bottomBar.addSubview(checkButton)
        bottomBar.addSubview(trashButton)
        
//        forwardButton.addTarget(self, action: "forwardParagraph", forControlEvents: .TouchUpInside)
//        backwardButton.addTarget(self, action: "backwardParagraph", forControlEvents: .TouchUpInside)
        
        backwardButton.setBackgroundImage(UIImage(named: "back"), forState: .Normal)
        forwardButton.setBackgroundImage(UIImage(named: "forward"), forState: .Normal)
        checkButton.setBackgroundImage(UIImage(named: "check"), forState: .Normal)
        checkButton.setBackgroundImage(UIImage(named: "check-disabled"), forState: .Disabled)
        trashButton.setBackgroundImage(UIImage(named: "trash"), forState: .Normal)
        
        backwardButton.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(30)
            make.width.equalTo(45)
            make.centerY.equalTo(bottomBar.snp_centerY)
            make.left.equalTo(bottomBar.snp_left).offset(5)
        }
        forwardButton.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(30)
            make.width.equalTo(45)
            make.centerY.equalTo(bottomBar.snp_centerY)
            make.right.equalTo(bottomBar.snp_right).offset(-5)
        }
        recordButton.snp_makeConstraints { (make) -> Void in
            make.height.width.equalTo(40)
            make.center.equalTo(bottomBar.center)
        }
        checkButton.snp_makeConstraints { (make) -> Void in
            make.height.width.equalTo(35)
            make.left.equalTo(recordButton.snp_right).offset(30)
            make.centerY.equalTo(bottomBar.snp_centerY)
        }
        trashButton.snp_makeConstraints { (make) -> Void in
            make.height.width.equalTo(35)
            make.right.equalTo(recordButton.snp_left).offset(-30)
            make.centerY.equalTo(bottomBar.snp_centerY)
        }

    }
    
    func loadAddressURL() {
        let requestURL = NSURL(string: initialURL)
        let request = NSURLRequest(URL: requestURL!)
        webView.loadRequest(request)
    }
}