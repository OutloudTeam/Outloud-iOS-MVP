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
    var tableView = UITableView()
//    @IBOutlet var superView: UIView!
    var scrollView: UIScrollView!
    var playOrPause = false
    
    var backgroundMusic : AVAudioPlayer?
    func playSound()  {
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
    
    override func viewDidAppear(animated: Bool) {
        if let backgroundMusic = setupAudioPlayerWithFile("backyardBees", type:"mp3") {
            self.backgroundMusic = backgroundMusic
        }
    }
    override func viewDidLoad() {
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
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let paragraph = UILabel()
        paragraph.text = holdingArray[indexPath.row]
        let fontTest = UIFont(name: "Helvetica", size: 14.0)
        paragraph.font = fontTest
        var cellHeight = heightForView(paragraph.text!, font: fontTest!, width: (tableView.frame.width - 60))
        cellHeight = cellHeight + 10
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
        articleTitle.adjustsFontSizeToFitWidth = true
        articleTitle.textColor = black
        articleBar.addSubview(articleTitle)
        articleTitle.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(articleBar).offset(30)
            make.top.equalTo(articleBar).offset(5)
            make.right.equalTo(articleBar.snp_right).offset(-30)
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
        authorName.text = "Laura Wagner"
        authorName.font = UIFont(name: ".SFUIText-Light", size: 10)
        articleBar.addSubview(authorName)
        authorName.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(separatorBar.snp_bottom)
            make.left.equalTo(separatorBar.snp_left)
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
        return articleBar
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
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
func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.ByWordWrapping
    label.font = font
    label.text = text
    
    label.sizeToFit()
    return label.frame.height
}

