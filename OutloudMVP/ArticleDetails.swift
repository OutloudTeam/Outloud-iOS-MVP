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


class ArticleDetail: UIViewController {
    @IBOutlet var superView: UIView!
    var scrollView: UIScrollView!
    var playOrPause = false
    
    var backgroundMusic : AVAudioPlayer?
    func playSound()  {
        if playOrPause == false {
            playOrPause = true
            backgroundMusic?.play()
        } else {
            playOrPause = false
            backgroundMusic?.pause()
        }
    }
    func sliderValueDidChange(sender:UISlider)
    {
        backgroundMusic?.volume = sender.value
    }
    
    override func viewDidAppear(animated: Bool) {
        if let backgroundMusic = setupAudioPlayerWithFile("TestAudio", type:"mp3") {
            self.backgroundMusic = backgroundMusic
        }
    }
    
    override func viewDidLoad() {
        
        let topBar = createTopBar(superView)
        let articleBar = createTitleAuthorBarListen(superView)
        let bottomBar = createBottomBar(superView)
        scrollView = UIScrollView()
        superView.addSubview(scrollView)
        scrollView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(topBar.snp_bottom)
            make.bottom.equalTo(bottomBar.snp_top)
        }
        scrollView.backgroundColor = UIColor.redColor()

        //Bottom bar
        let playButton = UIButton(type: UIButtonType.System) as UIButton
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
        let volumeSlider = UISlider(frame:CGRectMake(20, 260, 280, 20))
        volumeSlider.minimumValue = 0
        volumeSlider.maximumValue = 10
        volumeSlider.continuous = true
        volumeSlider.tintColor = UIColor.redColor()
        volumeSlider.value = 5
        bottomBar.addSubview(volumeSlider)
        volumeSlider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
        volumeSlider.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(bottomBar.snp_centerY)
            make.width.height.equalTo(80)
            make.right.equalTo(playButton.snp_left).offset(-20)
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
