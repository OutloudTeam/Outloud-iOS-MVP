//
//  RecordIndividualParagraph.swift
//  OutloudMVP
//
//  Created by Frederik Lohner on 27/Oct/15.
//  Copyright © 2015 Outloud. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class Recorder {
    
    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    
    var soundFileURL:NSURL!
    
    init() {
    }
    
    func isRecording() -> Bool {
        
        if self.recorder != nil {
            return self.recorder.recording
        }
        return false
    }
    
    func isPlaying() -> Bool {
        if self.player != nil {
            return self.player.playing
        }
        return false
    }
    
    func startRecording() {
        
        if(self.soundFileURL != nil) {
            try! NSFileManager().removeItemAtURL(self.soundFileURL)
        }
        
        // First stop the player
        if player != nil && player.playing {
            player.stop()
        }
        
        if(recorder != nil && recorder.recording){
            print("already, do not call startRecording() it would't do anything")
            return
        }
        
        // Create the recorder is it's not initialized yet.
//        if recorder == nil {
        
            // Recorder settings
            var recordSettings = [
                AVFormatIDKey: NSNumber(unsignedInt:kAudioFormatAppleLossless),
                AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
                AVEncoderBitRateKey : 320000,
                AVNumberOfChannelsKey: 2,
                AVSampleRateKey : 44100.0
            ]
            // URL for the audio file
            let format = NSDateFormatter()
            format.dateFormat="yyyy-MM-dd-HH-mm-ss"
            let currentFileName = "recording-\(format.stringFromDate(NSDate())).m4a"
            print(currentFileName)
            
            let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            self.soundFileURL = documentsDirectory.URLByAppendingPathComponent(currentFileName)
            
            
            // Record with permission
            do {
                
                let session:AVAudioSession = AVAudioSession.sharedInstance()
                try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
                // ios 8 and later
                if (session.respondsToSelector("requestRecordPermission:")) {
                    AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                        if granted {
                            print("Permission to record granted")
                            self.recorder = try! AVAudioRecorder(URL: self.soundFileURL, settings: recordSettings)
                            self.recorder.record()
                        } else {
                            print("Permission to record not granted")
                        }
                    })
                } else {
                    print("requestRecordPermission unrecognized")
                }
            } catch {
                print("Could not initialize AVAudioRecorder")
            }
        
    }
    
    func stopRecording() {
        if (self.recorder != nil) {
            self.recorder.stop()
        }
    }
    
    func startPlaying() {
        self.player = try! AVAudioPlayer(contentsOfURL: self.soundFileURL)
        
        if(!self.player.playing) {
            if(self.recorder.recording) {
                self.recorder.stop()
            }
            self.player.play()
        }
    }
    
    func stopPlaying() {
        if(self.player != nil && self.player.playing) {
            self.player.stop()
        }
    }
    
}

class RecordIndividualParagraph: UIViewController, UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate {
    let backwardButton = UIButton(type: UIButtonType.System) as UIButton
    let forwardButton = UIButton(type: UIButtonType.System) as UIButton
    var tableView = UITableView(frame: CGRectMake(100, 100, 100, 100), style: .Grouped)
    let completionBar = UIView()
    var completionWidth : CGFloat!
    func forwardParagraph() {
        backwardButton.hidden = false
        if(ParagraphCount < FullArticleContentArray.count-1) {
            if (ParagraphCount+1 == FullArticleContentArray.count-1) {
                forwardButton.hidden = true
            } else {
                forwardButton.hidden = false
            }
            ParagraphCount++
            self.navigationItem.titleView = createNavigationTitleViewArticleRecordParagraph("Pargraph \(ParagraphCount+1) / \(FullArticleContentArray.count)", callback: { () -> Void in
            })
            tableView.reloadData()
//            completionWidth = self.view.frame.width * (CGFloat(ParagraphCount+1) / CGFloat(FullArticleContentArray.count))
//            completionBar.snp_updateConstraints(closure: { (make) -> Void in
//                make.width.equalTo(completionWidth)
//            })
        }
        checkButton.enabled = false
        playbackButton.enabled = false
        timeLabel.text = "00:00"
    }
    func backwardParagraph() {
        forwardButton.hidden = false
        if(ParagraphCount > 0) {
            if (ParagraphCount-1 == 0) {
                backwardButton.hidden = true
            } else {
                backwardButton.hidden = false
            }
            ParagraphCount--
            self.navigationItem.titleView = createNavigationTitleViewArticleRecordParagraph("Pargraph \(ParagraphCount+1) / \(FullArticleContentArray.count)", callback: { () -> Void in
            })
            tableView.reloadData()
//            completionWidth = self.view.frame.width * (CGFloat(ParagraphCount+1) / CGFloat(FullArticleContentArray.count))
//            completionBar.snp_updateConstraints(closure: { (make) -> Void in
//                make.width.equalTo(completionWidth)
//            })
        }
    }
    
    var recordButton : RecordButton!
    var checkButton : UIButton!
    var playbackButton : UIButton!
    var timeLabel : UILabel!
    var timer : NSTimer!
    var playerTimer : NSTimer!
    var audioFiles : NSMutableArray!
    override func viewDidLoad() {
        
        let playbackToolbar = UIView(frame: CGRect(x: 0, y: 0, width: 128, height: 32))
        
        // play button
        playbackButton = UIButton()
        playbackButton.setBackgroundImage(UIImage(named: "play-button"), forState: .Normal)
        playbackButton.setBackgroundImage(UIImage(named: "stop"), forState: .Selected)
        playbackToolbar.addSubview(playbackButton)
        playbackButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(playbackToolbar)
            make.centerY.equalTo(playbackToolbar.snp_centerY)
            make.width.height.equalTo(25)
        }
        playbackButton.addTarget(self, action: "playback_tapped", forControlEvents: .TouchUpInside)
        
        // time label
        timeLabel = UILabel()
        timeLabel.font = mediumTitleFont
        timeLabel.text = "00:00"
        timeLabel.textColor = barTextColor
        timeLabel.textAlignment = .Right
        playbackToolbar.addSubview(timeLabel)
        timeLabel.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(playbackButton.snp_leftMargin).inset(-20)
            make.centerY.equalTo(playbackToolbar.snp_centerY)
            make.left.equalTo(playbackToolbar.snp_leftMargin)
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: playbackToolbar)
        
        completionWidth = self.view.frame.width * (CGFloat(ParagraphCount+1) / CGFloat(FullArticleContentArray.count))
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.navigationItem.titleView = createNavigationTitleViewArticleRecordParagraph("Pargraph \(ParagraphCount+1) / \(FullArticleContentArray.count)", callback: { () -> Void in
        })
        self.view.addSubview(completionBar)
        if(ParagraphCount == 0) {
            backwardButton.hidden = true
        } else if (ParagraphCount+1 == FullArticleContentArray.count) {
            forwardButton.hidden = true
        }
        completionBar.backgroundColor = recordProgressColor
        completionBar.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(4)
            make.width.greaterThanOrEqualTo(completionWidth)
            make.left.top.equalTo(self.view)
        }
        let bottomBar = createBottomParagraphRecordingBar(self.view)
        self.view.addSubview(tableView)
        tableView.backgroundColor = backgroundColorAll
        self.view.backgroundColor = backgroundColorAll
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Test")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        //        tableView.scrollEnabled = false
        tableView.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(self.view)
            make.top.equalTo(completionBar.snp_bottom)
            make.bottom.equalTo(bottomBar.snp_top)
        }
        //Bottom bar buttons
        recordButton = RecordButton()//UIButton(type: UIButtonType.System) as UIButton
        checkButton = UIButton(type: UIButtonType.System) as UIButton
        let trashButton = UIButton(type: UIButtonType.System) as UIButton
        
        checkButton.enabled = false
        playbackButton.enabled = false
        
        recordButton.addTarget(self, action: "record_tapped:", forControlEvents: UIControlEvents.TouchUpInside)
        checkButton.addTarget(self, action: "check_tapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        forwardButton.frame = CGRectMake(50, 50, 70, 50)
        recordButton.frame = CGRectMake(100,100,100,100)
        bottomBar.addSubview(backwardButton)
        bottomBar.addSubview(forwardButton)
        bottomBar.addSubview(recordButton)
        bottomBar.addSubview(checkButton)
        bottomBar.addSubview(trashButton)
        
        forwardButton.addTarget(self, action: "forwardParagraph", forControlEvents: .TouchUpInside)
        backwardButton.addTarget(self, action: "backwardParagraph", forControlEvents: .TouchUpInside)
        
        backwardButton.setBackgroundImage(UIImage(named: "back"), forState: .Normal)
        forwardButton.setBackgroundImage(UIImage(named: "forward"), forState: .Normal)
        checkButton.setBackgroundImage(UIImage(named: "check"), forState: .Normal)
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
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellHeight = heightForJustifiedView(FullArticleContentArray[ParagraphCount].text!, font: recordArticleParagraphFont, width: (tableView.frame.width - 60), lineSpace: 5)
        //cell height is dynamically generated then constraint values are added
        return cellHeight + 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return generateRecordingParagraphCell(tableView, indexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return generateRecordingHeaderCell(tableView)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let titleHeight = heightForJustifiedView(ArticleDetailArray[0].title!, font: recordArticleTitleFont, width: (tableView.frame.width - 60), lineSpace: 3)
        let authorHeight = heightForJustifiedView(ArticleDetailArray[0].author!, font: authorNameFont, width: (tableView.frame.width-60), lineSpace: 3)
        let articleHeight = heightForView("Placeholder.com", font: articleLinkFont, width: (tableView.frame.width - 60))
        //cell height is dynamically genrated then the constraint values are added to it
        return titleHeight + authorHeight + articleHeight + 67
    }
    
    let recorder = Recorder()
    func record_tapped(sender: UIButton) {
        if(recorder.isRecording()) {
            recorder.stopRecording()
            checkButton.enabled = true
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
    
    func check_tapped(sender: UIButton) {
        
        // upload the file if there is any.
        
        if(ParagraphCount >= FullArticleContentArray.count-1) {
            // you're good, go back to the paragraph
            self.navigationController?.popViewControllerAnimated(true)
        } else {
             forwardParagraph()
        }
        
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
    
    func updateAudioMeter() {
        if(recorder.recorder != nil) {
            
            let minutes = floor(recorder.recorder.currentTime/60)
            let seconds = recorder.recorder.currentTime - (minutes * 60)
            
            self.timeLabel.text = String.localizedStringWithFormat("%02d:%02d", Int(minutes), Int(seconds))
        }
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