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

class CustomRecordWebView: UIViewController, AVAudioPlayerDelegate {
    let webView = UIWebView()
    let backgroundView = UIView()
    let initialURL = "http://google.com"
    
    var recordButton : RecordButton!
    let recorder = Recorder()
    var checkButton : UIButton!
    var playbackButton = UIButton()
    let backwardButton = UIButton(type: UIButtonType.System) as UIButton
    let forwardButton = UIButton(type: UIButtonType.System) as UIButton
    let completionBar = UIView()
    var timeLabel = UILabel()
    var timer : NSTimer!
    var playerTimer : NSTimer!
    var audioFiles : NSMutableArray!
    var recordingsCount = 1
    
    
    override func viewDidLoad() {
        // Clear all previous recordings
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        if let enumerator = NSFileManager.defaultManager().enumeratorAtPath(documentsDirectory.absoluteString) {
            while let fileName = enumerator.nextObject() as? String {
                do {
                    try NSFileManager.defaultManager().removeItemAtPath("\(documentsDirectory)\(fileName)")
                    print("deleted file: \(fileName)")
                }
                catch let e as NSError {
                    print(e)
                }
                catch {
                    print("error")
                }
            }
        }
        
        // Setup playback toolbar and button
        let playbackToolbar = UIView(frame: CGRect(x: 0, y: 0, width: 128, height: 32))
        
        playbackButton.enabled = false
        playbackButton.setBackgroundImage(UIImage(named: "play-button"), forState: .Normal)
        playbackButton.setBackgroundImage(UIImage(named: "pause-button"), forState: .Selected)
        playbackToolbar.addSubview(playbackButton)
        playbackButton.addTarget(self, action: "playback_tapped", forControlEvents: .TouchUpInside)
        
        playbackButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(playbackToolbar)
            make.centerY.equalTo(playbackToolbar.snp_centerY)
            make.width.height.equalTo(25)
        }
        
        timeLabel.font = mediumTitleFont
        timeLabel.text = "00:00"
        timeLabel.textColor = redColor
        timeLabel.textAlignment = .Right
        playbackToolbar.addSubview(timeLabel)
        timeLabel.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(playbackButton.snp_leftMargin).inset(-20)
            make.centerY.equalTo(playbackToolbar.snp_centerY)
            make.left.equalTo(playbackToolbar.snp_leftMargin)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: playbackToolbar)
        
        self.view.addSubview(webView)
        self.view.addSubview(completionBar)
        completionBar.backgroundColor = recordProgressColor
        completionBar.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(4)
            make.width.greaterThanOrEqualTo(0)
            make.left.top.equalTo(self.view)
        }
        let bottomBar = createBottomParagraphRecordingBar(self.view)
        webView.snp_makeConstraints { (make) -> Void in
            make.left.right.top.equalTo(self.view)
            make.bottom.equalTo(bottomBar.snp_top)
        }
        loadAddressURL()
        
        //Bottom bar buttons
        recordButton = RecordButton()//UIButton(type: UIButtonType.System) as UIButton
        recordButton.addTarget(self, action: "record_tapped", forControlEvents: UIControlEvents.TouchUpInside)
        
        checkButton = UIButton(type: UIButtonType.System) as UIButton
        checkButton.hidden = true
        
        forwardButton.frame = CGRectMake(50, 50, 70, 50)
        recordButton.frame = CGRectMake(100,100,100,100)
        bottomBar.addSubview(backwardButton)
        bottomBar.addSubview(forwardButton)
        bottomBar.addSubview(recordButton)
        bottomBar.addSubview(checkButton)
        
        //        forwardButton.addTarget(self, action: "forwardParagraph", forControlEvents: .TouchUpInside)
        //        backwardButton.addTarget(self, action: "backwardParagraph", forControlEvents: .TouchUpInside)
        
        backwardButton.setBackgroundImage(UIImage(named: "back"), forState: .Normal)
        forwardButton.setBackgroundImage(UIImage(named: "forward"), forState: .Normal)
        checkButton.setBackgroundImage(UIImage(named: "check"), forState: .Normal)
        checkButton.setBackgroundImage(UIImage(named: "check-disabled"), forState: .Disabled)
        
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
        
    }
    
    func record_tapped() {
        if(recorder.isRecording()) {
            recorder.stopRecording()
            // save the url
            print(ParagraphCount)
            let newElement = FullArticleContent(text: "none", readings: "none", recordingUrl: recorder.soundFileURL)
            if WebViewFullArticleContentArray.count < recordingsCount {
                WebViewFullArticleContentArray.append(newElement)
            } else {
                WebViewFullArticleContentArray[recordingsCount-1].recordingUrl = recorder.soundFileURL
            }
            print(WebViewFullArticleContentArray)
            //            FullArticleContentArray[ParagraphCount].recordingUrl = recorder.soundFileURL
            recordButton.setRecording(false, animate: true)
            playbackButton.enabled = true
            print(recorder.isRecording())
            timer.invalidate()
            timer = nil
        } else {
            recorder.startRecording()
            checkButton.enabled = false
            playbackButton.enabled = false
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1,
                target:self,
                selector:"updateAudioMeter",
                userInfo:nil,
                repeats:true)
            print(recorder.isRecording())
        }
    }
    
    func updateAudioMeter() {
        if(recorder.recorder != nil) {
            
            let minutes = floor(recorder.recorder.currentTime/60)
            let seconds = recorder.recorder.currentTime - (minutes * 60)
            
            self.timeLabel.text = String.localizedStringWithFormat("%02d:%02d", Int(minutes), Int(seconds))
        }
    }
    
    func resetPlayer() {
        let currentArticle = FullArticleContentArray[ParagraphCount]
        if(currentArticle.recordingUrl != nil) {
            recorder.soundFileURL = currentArticle.recordingUrl!
            recorder.player = try! AVAudioPlayer(contentsOfURL: currentArticle.recordingUrl!)
            playbackButton.enabled = true
            timeLabel.text = String.localizedStringWithFormat("%02d:%02d", Int(recorder.player.duration) / 60, Int(recorder.player.duration) % 60)
        } else {
            recorder.soundFileURL = nil
            playbackButton.enabled = false
            timeLabel.text = "00:00"
            
        }
        checkButton.enabled = false
    }
    
    func loadAddressURL() {
        let requestURL = NSURL(string: initialURL)
        let request = NSURLRequest(URL: requestURL!)
        webView.loadRequest(request)
    }
    func playback_tapped() {
        playbackButton.selected = !playbackButton.selected
        if(recorder.isPlaying()){
            recorder.stopPlaying()
            playerTimer.invalidate()
            playerTimer = nil
            completionBar.snp_updateConstraints(closure: { (make) -> Void in
                make.width.equalTo(0)
            })
            print(recorder.isPlaying())
        } else {
            recordButton.setRecording(false, animate: true)
            recorder.startPlaying()
            print(recorder.isPlaying())
            playerTimer = NSTimer.scheduledTimerWithTimeInterval(0.01,
                target:self,
                selector:"updatePlaybackProgress",
                userInfo:nil,
                repeats:true)
        }
        recorder.player.delegate = self
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        completionBar.snp_updateConstraints(closure: { (make) -> Void in
            make.width.equalTo(0)
        })
        playbackButton.selected = false
        playerTimer.invalidate()
        playerTimer = nil
    }
    
    func updatePlaybackProgress() {
        if(recorder.player != nil) {
            
            let total = recorder.player.duration
            let f = recorder.player.currentTime / total;
            let w = view.frame.width * CGFloat(f)
            
            completionBar.snp_updateConstraints(closure: { (make) -> Void in
                make.width.equalTo(w)
            })
            
        }
    }
}