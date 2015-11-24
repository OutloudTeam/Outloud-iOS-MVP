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
import Alamofire

func mergeAudioFiles(audioFileUrls: NSArray, callback: (url: NSURL?, error: NSError?)->()) {
    
    // Create the audio composition
    let composition = AVMutableComposition()

    // Merge
    for (var i = 0; i < audioFileUrls.count; i++) {
        
        let compositionAudioTrack :AVMutableCompositionTrack = composition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())
        
        let asset = AVURLAsset(URL: audioFileUrls[i] as! NSURL)
        
        let track = asset.tracksWithMediaType(AVMediaTypeAudio)[0]
        
        let timeRange = CMTimeRange(start: CMTimeMake(0, 600), duration: track.timeRange.duration)
        
        try! compositionAudioTrack.insertTimeRange(timeRange, ofTrack: track, atTime: composition.duration)
    }
    
    // Create output url
    let format = NSDateFormatter()
    format.dateFormat="yyyy-MM-dd-HH-mm-ss"
    let currentFileName = "recording-\(format.stringFromDate(NSDate()))-merge.m4a"
    print(currentFileName)
    
    let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    let outputUrl = documentsDirectory.URLByAppendingPathComponent(currentFileName)
    print(outputUrl.absoluteString)
    
    // Export it
    let assetExport = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetAppleM4A)
    assetExport?.outputFileType = AVFileTypeAppleM4A
    assetExport?.outputURL = outputUrl
    
    assetExport?.exportAsynchronouslyWithCompletionHandler({ () -> Void in
        switch assetExport!.status {
            case AVAssetExportSessionStatus.Failed:
                callback(url: nil, error: assetExport?.error)
            default:
                callback(url: assetExport?.outputURL, error: nil)
        }
    })
    
}

// this function creates the required URLRequestConvertible and NSData we need to use Alamofire.upload
func urlRequestWithComponents(urlString:String, parameters:Dictionary<String, String>, imageData:NSData) -> (URLRequestConvertible, NSData) {
    
    // create url request to send
    let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
    mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
    let boundaryConstant = "myRandomBoundary12345";
    let contentType = "multipart/form-data;boundary="+boundaryConstant
    mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
    
    
    
    // create upload data to send
    let uploadData = NSMutableData()
    
    // add image
    uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
    uploadData.appendData("Content-Disposition: form-data; name=\"file\"; filename=\"file.m4a\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
    uploadData.appendData("Content-Type: audio/mp4\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
    uploadData.appendData(imageData)
    
    // add parameters
    for (key, value) in parameters {
        uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
    }
    uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
    
    
    
    // return URLRequestConvertible and NSData
    return (Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
}

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
            try! NSFileManager.defaultManager().removeItemAtURL(self.soundFileURL)
            print("Removed previous recording.")
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
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.DefaultToSpeaker)
        } catch {
            print("Could not set the default to speaker")
        }
        
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
    let forwardParagraphLabel = UILabel()
    var tableView = UITableView(frame: CGRectMake(100, 100, 100, 100), style: .Grouped)
    let completionBar = UIView()
    var completionWidth : CGFloat!
    
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
    
    func forwardParagraph() {
        // stop recording and playing
        if(recorder.isPlaying()) {
            playback_tapped()
        }
        
        if(recorder.isRecording()) {
            record_tapped()
        }
        
        backwardButton.hidden = false
        if(ParagraphCount < FullArticleContentArray.count-1) {
            if (ParagraphCount+1 == FullArticleContentArray.count-1) {
                forwardButton.hidden = true
                forwardParagraphLabel.hidden = true
            } else {
                forwardButton.hidden = false
                forwardParagraphLabel.hidden = true
            }
            ParagraphCount++
            self.navigationItem.titleView = createNavigationTitleViewArticleRecordParagraph("Paragraph \(ParagraphCount+1) / \(FullArticleContentArray.count)", callback: { () -> Void in
            })
            tableView.reloadData()
            
            // Reset player
            resetPlayer()
            
//            completionWidth = self.view.frame.width * (CGFloat(ParagraphCount+1) / CGFloat(FullArticleContentArray.count))
//            completionBar.snp_updateConstraints(closure: { (make) -> Void in
//                make.width.equalTo(completionWidth)
//            })
        }
    }
    func backwardParagraph() {
        forwardButton.hidden = false
        if(ParagraphCount > 0) {
            if (ParagraphCount-1 == 0) {
                backwardButton.hidden = true
                forwardParagraphLabel.hidden = false
            } else {
                backwardButton.hidden = false
                forwardParagraphLabel.hidden = true
            }
            ParagraphCount--
            self.navigationItem.titleView = createNavigationTitleViewArticleRecordParagraph("Paragraph \(ParagraphCount+1) / \(FullArticleContentArray.count)", callback: { () -> Void in
            })
            tableView.reloadData()
            
            // Reset player
            resetPlayer()
            
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
        // debug
        
        // end debug
        
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
        
        // Setup UI
        let playbackToolbar = UIView(frame: CGRect(x: 0, y: 0, width: 128, height: 32))
        
        // play button
        playbackButton = UIButton()
        playbackButton.setBackgroundImage(UIImage(named: "play-button"), forState: .Normal)
        playbackButton.setBackgroundImage(UIImage(named: "pause-button"), forState: .Selected)
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
        timeLabel.textColor = redColor
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
            forwardParagraphLabel.hidden = false
        } else if (ParagraphCount+1 == FullArticleContentArray.count) {
            forwardButton.hidden = true
        }
        completionBar.backgroundColor = recordProgressColor
        completionBar.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(4)
            make.width.greaterThanOrEqualTo(0)
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
//        checkButton.hidden = true
        
        let trashButton = UIButton(type: UIButtonType.System) as UIButton
        trashButton.hidden = true
        checkButton.enabled = false
        playbackButton.enabled = false
        
        recordButton.addTarget(self, action: "record_tapped", forControlEvents: UIControlEvents.TouchUpInside)
        checkButton.addTarget(self, action: "check_tapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        forwardButton.frame = CGRectMake(50, 50, 70, 50)
        recordButton.frame = CGRectMake(100,100,100,100)
        bottomBar.addSubview(backwardButton)
        bottomBar.addSubview(forwardButton)
        bottomBar.addSubview(recordButton)
        bottomBar.addSubview(checkButton)
        bottomBar.addSubview(trashButton)
        bottomBar.addSubview(forwardParagraphLabel)
        
        forwardButton.addTarget(self, action: "forwardParagraph", forControlEvents: .TouchUpInside)
        backwardButton.addTarget(self, action: "backwardParagraph", forControlEvents: .TouchUpInside)
        
        backwardButton.setBackgroundImage(UIImage(named: "back"), forState: .Normal)
        forwardButton.setBackgroundImage(UIImage(named: "forward"), forState: .Normal)
        checkButton.setBackgroundImage(UIImage(named: "upload"), forState: .Normal)
        checkButton.setBackgroundImage(UIImage(named: "upload-disabled"), forState: .Disabled)
        trashButton.setBackgroundImage(UIImage(named: "trash"), forState: .Normal)
        
        forwardParagraphLabel.text = "Next"
        forwardParagraphLabel.font = UIFont.systemFontOfSize(14, weight: UIFontWeightLight)
        forwardParagraphLabel.textColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
        forwardParagraphLabel.textAlignment = .Right
        forwardParagraphLabel.adjustsFontSizeToFitWidth = true
        
        if(ParagraphCount != 0) {
            forwardParagraphLabel.hidden = true
        }
        
        forwardParagraphLabel.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(forwardButton.snp_left).offset(-2)
            make.height.centerY.equalTo(forwardButton)
            make.left.equalTo(recordButton.snp_right).offset(5)
        }

        
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
        if(ParagraphCount == 0) {
            return generateRecordingHeaderCell(tableView)
        } else {
            return nil
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(ParagraphCount == 0) {

        let titleHeight = heightForJustifiedView(ArticleDetailArray[0].title!, font: recordArticleTitleFont, width: (tableView.frame.width - 60), lineSpace: 3)
        let authorHeight = heightForJustifiedView(ArticleDetailArray[0].author!, font: authorNameFont, width: (tableView.frame.width-60), lineSpace: 3)
        let articleHeight = heightForView("Placeholder.com", font: articleLinkFont, width: (tableView.frame.width - 60))
        //cell height is dynamically genrated then the constraint values are added to it
        return titleHeight + authorHeight + articleHeight + 67
        } else {
            return 0
        }
    }
    
    let recorder = Recorder()
    func record_tapped() {
        if(recorder.isRecording()) {
            recorder.stopRecording()
            // save the url
            print(ParagraphCount)
            FullArticleContentArray[ParagraphCount].recordingUrl = recorder.soundFileURL
            checkButton.enabled = true
            for(var i = 0; i < FullArticleContentArray.count; i++) {
                if(FullArticleContentArray[i].recordingUrl == nil) {
                    checkButton.enabled = false
                    break
                }
            }
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
    
    func check_tapped(sender: UIButton) {
        
        // upload the file if there is any.
        
        if(ParagraphCount >= FullArticleContentArray.count-1) {
            // you're good, go back to the paragraph
            
            let audioFiles = NSMutableArray()
            for(var i = 0; i < FullArticleContentArray.count; i++) {
                audioFiles.addObject(FullArticleContentArray[i].recordingUrl!)
            }
            mergeAudioFiles(audioFiles, callback: { (url, error) -> () in
                
                if(url != nil) {
                    let parameters = ["article_id":CurrentArticleUuid!,"is_human":"true","reader_id":"Peyman MO","email":"pkd2008@hotmail.com"]
                    
                    let data = NSData(contentsOfURL: url!)
                    
                    let request = urlRequestWithComponents("http://www.outloud.io:8080/api/reading/new", parameters: parameters, imageData: data!)
                    
                    Alamofire.upload(request.0, data: request.1)
                }
                
            })
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