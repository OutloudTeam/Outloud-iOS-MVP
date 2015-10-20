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
import AVFoundation


class ArticleDetail: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let playButton = UIButton(type: UIButtonType.System) as UIButton
    let skipBackButton = UIButton(type: UIButtonType.System) as UIButton
    let skipForwardButton =  UIButton(type: UIButtonType.System) as UIButton
    var tableView = UITableView()
    var scrollView: UIScrollView!
    var playOrPause = false
    var firstTime = true
    var backgroundMusic : AVAudioPlayer?
    var indexToColor = -1
    func playSound()  {
        if firstTime == true {
            firstTime = false
            delay(14.6, closure: { () -> () in
                self.indexToColor = 1
                self.tableView.reloadData()
            })
            delay(6.4, closure: { () -> () in
                self.indexToColor = 0
                self.tableView.reloadData()
            })
        }
        if playOrPause == false {
            playOrPause = true
            playButton.setBackgroundImage(UIImage(named: "play-button-clicked"), forState: .Normal)
            backgroundMusic?.play()
        } else {
            playOrPause = false
            playButton.setBackgroundImage(UIImage(named: "play-button"), forState: .Normal)
            backgroundMusic?.pause()
        }
    }
    func sliderValueDidChange(sender:UISlider) {
        backgroundMusic?.volume = sender.value
    }
    func playerItemDidReachEnd(note: NSNotification) {
        playButton.setBackgroundImage(UIImage(named: "play-button"), forState: .Normal)
    }
    
    override func viewDidAppear(animated: Bool) {
        if let backgroundMusic = setupAudioPlayerWithFile("backyardBees", type:"mp3") {
            self.backgroundMusic = backgroundMusic
        }
    }
    override func viewDidLoad() {
        articleJSONGet { () -> () in
            
        }
        
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.navigationItem.titleView = createNavigationTitleView("Listen", callback: { () -> Void in
            NSLog("YO MAN")
        })
        
        let bottomBar = createBottomBar(self.view)
        //Bottom bar
        playButton.frame = CGRectMake(50, 50, 50, 50)
        playButton.setBackgroundImage(UIImage(named: "play-button"), forState: .Normal)
        bottomBar.addSubview(playButton)
        playButton.addTarget(self, action: "playSound", forControlEvents: .TouchUpInside)
        playButton.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(bottomBar)
            make.width.height.equalTo(40)
            make.centerX.equalTo(bottomBar.snp_centerX)
        }
        bottomBar.addSubview(skipBackButton)
        skipBackButton.frame = CGRectMake(50, 50, 50, 50)
        skipBackButton.setBackgroundImage(UIImage(named: "skip-back"), forState: .Normal)
        bottomBar.addSubview(playButton)
        skipBackButton.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(bottomBar.snp_centerY)
            make.width.height.equalTo(20)
            make.right.equalTo(playButton.snp_left).offset(-8)
        }
        bottomBar.addSubview(skipForwardButton)
        skipForwardButton.frame = CGRectMake(50, 50, 50, 50)
        skipForwardButton.setBackgroundImage(UIImage(named: "skip-forward"), forState: .Normal)
        bottomBar.addSubview(skipForwardButton)
        skipForwardButton.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(bottomBar.snp_centerY)
            make.width.height.equalTo(20)
            make.left.equalTo(playButton.snp_right).offset(8)
        }
        let volumeSlider = UISlider(frame:CGRectMake(20, 260, 380, 20))
        volumeSlider.minimumValue = 0
        volumeSlider.maximumValue = 10
        volumeSlider.continuous = true
        volumeSlider.tintColor = UIColor.redColor()
        volumeSlider.value = 8
        bottomBar.addSubview(volumeSlider)
        volumeSlider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
        volumeSlider.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(bottomBar.snp_centerY)
            make.width.height.equalTo(80)
            make.right.equalTo(playButton.snp_left).offset(-20)
        }
        volumeSlider.hidden = true
        
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Test")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.snp_makeConstraints { (make) -> Void in
            make.left.right.top.equalTo(self.view)
            make.bottom.equalTo(bottomBar.snp_top)
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return holdingArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let paragraph = UILabel()
        cell.addSubview(paragraph)
        paragraph.text = holdingArray[indexPath.row]
        paragraph.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraph.numberOfLines = 0
        paragraph.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(cell.snp_left).offset(30)
            make.right.equalTo(cell.snp_right).offset(-30)
            make.top.equalTo(cell.snp_top).offset(5)
        }
        let fontTest = UIFont(name: "Helvetica", size: 14.0)
        paragraph.font = fontTest
        paragraph.textColor = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1.0)
        if(indexToColor == indexPath.row){
            paragraph.textColor = UIColor.blackColor()
            let fontTest = UIFont(name: "Helvetica", size: 14.0)
            paragraph.font = fontTest
        }
        cell.userInteractionEnabled = false
    
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let paragraph = UILabel()
        paragraph.text = holdingArray[indexPath.row]
        let fontTest = UIFont(name: "Helvetica", size: 14.0)
        paragraph.font = fontTest
        var cellHeight = heightForView(paragraph.text!, font: fontTest!, width: (tableView.frame.width - 60))
        cellHeight = cellHeight + 10
//        if(indexToColor == indexPath.row){
//            let fontTest2 = UIFont(name: "Helvetica", size: 18.0)
//            paragraph.font = fontTest2
//            var cellHeight = heightForView(paragraph.text!, font: fontTest2!, width: (tableView.frame.width - 60))
//            cellHeight = cellHeight + 10
//        }
        return cellHeight
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let articleBar = UIView()
        self.view.addSubview(articleBar)
        articleBar.backgroundColor = UIColor.whiteColor()
        let articleTitle = UILabel()
        articleTitle.text = "Backyard Beekeeping Approved In Los Angeles"
        articleTitle.font = UIFont(name: ".SFUIText-Light", size: 24)
        articleTitle.textAlignment = .Center
        articleTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        articleTitle.numberOfLines = 0
//        articleTitle.adjustsFontSizeToFitWidth = true
        articleTitle.textColor = black
        articleBar.addSubview(articleTitle)
        articleTitle.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(articleBar).offset(30)
            make.top.equalTo(articleBar).offset(5)
            make.right.equalTo(articleBar.snp_right).offset(-30)
        }
        let authorName = UILabel()
        authorName.adjustsFontSizeToFitWidth = true
        authorName.text = "Laura Wagner"
        authorName.font = UIFont(name: ".SFUIText-Light", size: 10)
        articleBar.addSubview(authorName)
        authorName.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(articleTitle.snp_bottom)
            make.left.equalTo(articleTitle.snp_left).offset(5)
        }
        let articleLink = UILabel()
        articleLink.text = "npr.org/"
        articleLink.textColor = transparentBlack
        articleLink.font = UIFont(name: ".SFUIText-Light", size: 10)
        articleBar.addSubview(articleLink)
        articleLink.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(authorName.snp_left)
            make.top.equalTo(authorName.snp_bottom).offset(2)
        }
        let voiceName = UILabel()
        voiceName.adjustsFontSizeToFitWidth = true
        voiceName.text = "@VahidGF"
        voiceName.font = UIFont(name: ".SFUIText-Light", size: 12)
        articleBar.addSubview(voiceName)
        voiceName.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(articleTitle.snp_rightMargin)
            make.top.equalTo(authorName.snp_top)
        }
        let voiceRating = UIButton()
        articleBar.addSubview(voiceRating)
        voiceRating.setBackgroundImage(UIImage(named: "rating"), forState: UIControlState.Normal)
        voiceRating.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(voiceName.snp_bottom)
            make.left.equalTo(voiceName.snp_left)
            make.height.equalTo(10)
            make.width.equalTo(50)
        }
        let separatorBar = UIView()
        articleBar.addSubview(separatorBar)
        separatorBar.backgroundColor = UIColor.blackColor()
        separatorBar.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(1)
            make.top.equalTo(articleLink.snp_bottom).offset(3)
            make.left.equalTo(articleBar.snp_left).offset(50)
            make.right.equalTo(articleBar.snp_right).offset(-50)
        }
        return articleBar
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
}
func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer?  {
    let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
    let url = NSURL.fileURLWithPath(path!)

    var audioPlayer:AVAudioPlayer?
    do {
        try audioPlayer = AVAudioPlayer(contentsOfURL: url)
    } catch {
        print("Player not available")
    }
    return audioPlayer
}