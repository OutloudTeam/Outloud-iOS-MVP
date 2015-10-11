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


class SnapkitTests: UIViewController {
    @IBOutlet var superView: UIView!
    var scrollView: UIScrollView!
    
    var backgroundMusic : AVAudioPlayer?
    func playSound()  {
        backgroundMusic?.volume = 10.0
        backgroundMusic?.play()
    }
    override func viewDidAppear(animated: Bool) {
        if let backgroundMusic = setupAudioPlayerWithFile("TestAudio", type:"mp3") {
            self.backgroundMusic = backgroundMusic
//            playSound()
        }
    }
    
    
    override func viewDidLoad() {
        let topBar = UIView()
        let articleBar = UIView()
        let bottomBar = UIView()
        let middleView = UIView()
        let firstSlash = UILabel()
        let secondSlash = UILabel()

        
        superView.addSubview(topBar)
        superView.addSubview(articleBar)
        superView.addSubview(bottomBar)
        superView.addSubview(middleView)
        
        scrollView = UIScrollView(frame: middleView.bounds)
        middleView.addSubview(scrollView)
        scrollView.backgroundColor = UIColor.redColor()
        
        
        topBar.backgroundColor = topBarColor
        articleBar.backgroundColor = UIColor.whiteColor()
        middleView.backgroundColor = UIColor.blueColor()
        bottomBar.backgroundColor = darkRed
        
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
        middleView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(articleBar.snp_bottom)
            make.bottom.equalTo(bottomBar.snp_top)
            make.left.equalTo(superView).offset(0)
            make.right.equalTo(superView).offset(0)
        }
        bottomBar.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(75)
            make.bottom.equalTo(superView).offset(0)
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
        let authorRatingBarBackground = UIView()
        authorRatingBarBackground.backgroundColor = UIColor.whiteColor()
        authorRatingBarBackground.layer.borderColor = brightRed.CGColor
        authorRatingBarBackground.layer.borderWidth = 0.5
        articleBar.addSubview(authorRatingBarBackground)
        authorRatingBarBackground.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(3)
            make.top.equalTo(authorName.snp_bottom).offset(5)
            make.left.equalTo(authorLabel.snp_left)
            make.right.equalTo(authorName.snp_right)
        }
        let authorRatingBar = UIView()
        authorRatingBar.backgroundColor = UIColor.redColor()
        authorRatingBar.layer.borderColor = brightRed.CGColor
        authorRatingBar.layer.borderWidth = 0.5
        articleBar.addSubview(authorRatingBar)
        authorRatingBar.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(3)
            make.top.equalTo(authorName.snp_bottom).offset(5)
            make.left.equalTo(authorLabel.snp_left)
            make.right.equalTo(authorName.snp_right).offset(-40)
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
        let voiceRatingBarBackground = UIView()
        voiceRatingBarBackground.backgroundColor = UIColor.whiteColor()
        voiceRatingBarBackground.layer.borderColor = brightRed.CGColor
        voiceRatingBarBackground.layer.borderWidth = 0.5
        articleBar.addSubview(voiceRatingBarBackground)
        voiceRatingBarBackground.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(3)
            make.top.equalTo(voiceName.snp_bottom).offset(5)
            make.left.equalTo(authorLabel.snp_left)
            make.right.equalTo(authorName.snp_right)
        }
        let voiceRatingBar = UIView()
        voiceRatingBar.backgroundColor = UIColor.redColor()
        voiceRatingBar.layer.borderColor = brightRed.CGColor
        voiceRatingBar.layer.borderWidth = 0.5
        articleBar.addSubview(voiceRatingBar)
        voiceRatingBar.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(authorRatingBar.snp_height)
            make.top.equalTo(voiceName.snp_bottom).offset(5)
            make.left.equalTo(authorRatingBar.snp_left)
            make.right.equalTo(voiceName.snp_right).offset(-40)
        }
        
        let playButton   = UIButton(type: UIButtonType.System) as UIButton
        playButton.frame = CGRectMake(50, 50, 50, 50)
        playButton.setBackgroundImage(UIImage(named: "play-button"), forState: .Normal)
        playButton.setBackgroundImage(UIImage(named: "play-button-clicked"), forState: .Selected)
        bottomBar.addSubview(playButton)
        playButton.addTarget(self, action: "playSound", forControlEvents: .TouchUpInside)
        playButton.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(bottomBar)
            make.width.height.equalTo(60)
            make.centerX.equalTo(bottomBar.snp_centerX)
        }
        func buttonClicked(){
            print("KEK")
            playSound()
        }
        
        
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
