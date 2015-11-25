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
import Alamofire

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
    var currentRecording = 0
    var WebViewFullArticleContentArray = [FullArticleContent]()
    
    
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
        self.navigationItem.titleView = createNavigationTitleViewArticleRecordParagraph("Paragraph \(currentRecording+1) / \(WebViewFullArticleContentArray.count + 1)", callback: { () -> Void in
        })
        
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
        checkButton.enabled = false
        checkButton.addTarget(self, action: "preWebCheckTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        forwardButton.frame = CGRectMake(50, 50, 70, 50)
        recordButton.frame = CGRectMake(100,100,100,100)
        bottomBar.addSubview(backwardButton)
        bottomBar.addSubview(forwardButton)
        bottomBar.addSubview(recordButton)
        bottomBar.addSubview(checkButton)
        
        forwardButton.addTarget(self, action: "forwardParagraph", forControlEvents: .TouchUpInside)
        backwardButton.addTarget(self, action: "backwardParagraph", forControlEvents: .TouchUpInside)
        forwardButton.hidden = true
        backwardButton.hidden = true
        
        backwardButton.setBackgroundImage(UIImage(named: "back"), forState: .Normal)
        forwardButton.setBackgroundImage(UIImage(named: "plusParagraph"), forState: .Normal)
        checkButton.setBackgroundImage(UIImage(named: "upload"), forState: .Normal)
        checkButton.setBackgroundImage(UIImage(named: "upload-disabled"), forState: .Disabled)
        
        backwardButton.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(55)
            make.width.equalTo(55)
            make.centerY.equalTo(bottomBar.snp_centerY)
            make.left.equalTo(bottomBar.snp_left).offset(5)
        }
        forwardButton.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(55)
            make.width.equalTo(55)
            make.centerY.equalTo(bottomBar.snp_centerY)
            make.right.equalTo(bottomBar.snp_right).offset(-5)
        }
        recordButton.snp_makeConstraints { (make) -> Void in
            make.height.width.equalTo(60)
            make.center.equalTo(bottomBar.center)
        }
        checkButton.snp_makeConstraints { (make) -> Void in
            make.height.width.equalTo(45)
            make.right.equalTo(recordButton.snp_left).offset(-30)
            make.centerY.equalTo(bottomBar.snp_centerY)
        }
        
    }
    
    func record_tapped() {
        checkButton.enabled = true
        forwardButton.hidden = false
        forwardButton.enabled = true
        if(recorder.isRecording()) {
            recorder.stopRecording()
            // save the url
            let newElement = FullArticleContent(text: "none", readings: "none", recordingUrl: recorder.soundFileURL)
            if WebViewFullArticleContentArray.count < recordingsCount {
                WebViewFullArticleContentArray.append(newElement)
            } else {
                WebViewFullArticleContentArray[currentRecording].recordingUrl = recorder.soundFileURL
                WebViewFullArticleContentArray[currentRecording].text = newElement.text
            }
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
    
    var isForward = false
    func forwardParagraph() {
    
        if (!isForward) {
            let newElement = FullArticleContent(text: "", readings: "none", recordingUrl: nil)
            WebViewFullArticleContentArray.append(newElement)
            recordingsCount++
            forwardButton.enabled = false
        }
        
        if(recorder.isPlaying()) {
            playback_tapped()
        }
        
        if(recorder.isRecording()) {
            record_tapped()
        }
        
        currentRecording++

        if WebViewFullArticleContentArray.count == currentRecording+1 {
            forwardButton.setBackgroundImage(UIImage(named: "plusParagraph"), forState: .Normal)
            isForward = false
        } else {
            forwardButton.setBackgroundImage(UIImage(named: "forward"), forState: .Normal)
            isForward = true
        }
        
        backwardButton.hidden = false
        resetPlayer()
        self.navigationItem.titleView = createNavigationTitleViewArticleRecordParagraph("Paragraph \(currentRecording+1) / \(WebViewFullArticleContentArray.count)", callback: { () -> Void in
        })
    }
    
    func backwardParagraph() {
        isForward = true
        forwardButton.enabled = true
        forwardButton.hidden = false
        forwardButton.setBackgroundImage(UIImage(named: "forward"), forState: .Normal)
//        if(currentRecording > 0) {
            if (currentRecording-1 == 0) {
                forwardButton.setBackgroundImage(UIImage(named: "forward"), forState: .Normal)
                backwardButton.hidden = true
                //                forwardParagraphLabel.hidden = false
            } else {
                backwardButton.hidden = false
                //                forwardParagraphLabel.hidden = true
            }
            currentRecording--
        self.navigationItem.titleView = createNavigationTitleViewArticleRecordParagraph("Paragraph \(currentRecording+1) / \(WebViewFullArticleContentArray.count)", callback: { () -> Void in
        })
        
            // Reset player
            resetPlayer()
        
    }
    
    func updateAudioMeter() {
        if(recorder.recorder != nil) {
            
            let minutes = floor(recorder.recorder.currentTime/60)
            let seconds = recorder.recorder.currentTime - (minutes * 60)
            
            self.timeLabel.text = String.localizedStringWithFormat("%02d:%02d", Int(minutes), Int(seconds))
        }
    }
    
    func resetPlayer() {
        let currentArticle = WebViewFullArticleContentArray[currentRecording]
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
        //        checkButton.enabled = false
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
    
    func preWebCheckTapped(sender: UIButton) {
        let alert = UIAlertController(title: "Thanks!", message: "Your article will now appear in our listen ", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Enter name:"
            
        })
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Enter email:"
            
        })
        let sendAction = UIAlertAction(title: "Send", style: .Default) { (action) in
            var didFillFields = true
            for(var i=0;i<alert.textFields?.count;i++) {
                if alert.textFields![i].text == "" {
                    didFillFields = false
                }
            }
            if didFillFields == true {
                guard let name = alert.textFields![0].text! as? String,
                    let email = alert.textFields![1].text! as? String else {
                        return
                }
                self.webCheckTapped(name, email: email)
//                print(self.webView.request?.mainDocumentURL)
            }
        }
        alert.addAction(sendAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func webCheckTapped(name: String, email: String) {
        // upload the file if there is any.
        // you're good, go back to the paragraph
        let htmlTitle = webView.stringByEvaluatingJavaScriptFromString("document.title")
        
        let audioFiles = NSMutableArray()
        for(var i = 0; i < WebViewFullArticleContentArray.count; i++) {
            if(WebViewFullArticleContentArray[i].text! == "none") {
                audioFiles.addObject(WebViewFullArticleContentArray[i].recordingUrl!)
            }
        }
        mergeAudioFiles(audioFiles, callback: { (url, error) -> () in
            
            if(url != nil) {
                let parameters = ["is_human":"true","reader_id":"\(name)","email":"\(email)", "content_url":"\(self.webView.request!.mainDocumentURL!)", "title":"\(htmlTitle!)"]
                
                let data = NSData(contentsOfURL: url!)
                
                let request = urlRequestWithComponents("http://www.outloud.io:8080/api/reading/new", parameters: parameters, imageData: data!)
                
                Alamofire.upload(request.0, data: request.1)
            }
            
        })
        print("SENT")
        WebViewFullArticleContentArray = []
        self.navigationController?.popViewControllerAnimated(true)
    }
}