////
////  ReadingsIndividualArticle.swift
////  OutloudMVP
////
////  Created by Frederik Lohner on 13/Nov/15.
////  Copyright © 2015 Outloud. All rights reserved.
////
//
//import Foundation
//import UIKit
//import SnapKit
//import AVFoundation
//import SwiftOverlays
//import Alamofire
//
//class ReadingsIndividualArticle: UIViewController, UIActionSheetDelegate, AVAudioPlayerDelegate {
//    let playButton = UIButton(type: UIButtonType.System) as UIButton
//    let listenContainer = UIButton()
//    let middleView = UIView()
//    let progressView = ProgressView()
//    let playbackSpeedButton = UIButton()
//    
//    lazy var playOrPause = false
//    lazy var Readingplayer = AVAudioPlayer()
//    lazy var currentTrackIndex = 0
//    lazy var tracks:[String] = [String]()
//    var fileURL : NSURL!
//    var index: Int?
//    
//    var tableView = UITableView(frame: CGRectMake(100, 100, 100, 100), style: .Grouped)
//    let playAllButton = UIButton()
//    
//    func downloadFile() {
//        let destination: (NSURL, NSHTTPURLResponse) -> (NSURL) = {
//            (temporaryURL, response) in
//            
//            if let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as? NSURL {
//                self.fileURL = directoryURL.URLByAppendingPathComponent("\(ReadingsListArray[indexToListenAt].uuid)")
//                return directoryURL.URLByAppendingPathComponent("\(ReadingsListArray[indexToListenAt].uuid)")
//            }
//            return temporaryURL
//        }
//        
//        Alamofire.download(.GET, ReadingsListArray[indexToListenAt].url!, destination: destination)
//            .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
//                dispatch_async(dispatch_get_main_queue()) {
//                    let progress = (Double(totalBytesRead) / Double(totalBytesExpectedToRead)) * 100
//                    SwiftOverlays.showBlockingWaitOverlayWithText("Downloading Article: \(Int(progress))%!")
//                    print("Total bytes read on main queue: \(progress)")
//                }
//            }
//            .response { _, _, _, error in
//                if let error = error {
//                    print("Failed with error: \(error)")
//                    SwiftOverlays.removeAllBlockingOverlays()
//                } else {
//                    print("Downloaded file successfully")
//                    self.Readingplayer = AVAudioPlayer()
//                    SwiftOverlays.removeAllBlockingOverlays()
//                    do {
//                        let Readingplayer = try AVAudioPlayer(contentsOfURL: self.fileURL)
//                        self.Readingplayer = Readingplayer
//                        self.Readingplayer.delegate = self
//                    } catch {
//                        print(error)
//                    }
//                }
//        }
//    }
//    
//    func playFile() {
//        progressView.animateProgressView()
//        if (playOrPause == false) {
//            self.Readingplayer.play()
//            
//            playOrPause = true
//            playButton.setBackgroundImage(UIImage(named: "pause-button"), forState: .Normal)
//        } else {
//            self.Readingplayer.pause()
//            playOrPause = false
//            playButton.setBackgroundImage(UIImage(named: "play-button"), forState: .Normal)
//        }
//    }
//    
//    func getTrackURL(index: Int) {
//        if let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as? NSURL {
//            fileURL = directoryURL.URLByAppendingPathComponent("\(ReadingsListArray[index].uuid)")
//            directoryURL.URLByAppendingPathComponent("\(ReadingsListArray[index].uuid)")
//        }
//    }
//    
//    func getCurrentTimeAsString() -> String {
//        var seconds = 0
//        var minutes = 0
//        if let time = Readingplayer.currentTime as? Double {
//            seconds = Int(time) % 60
//            minutes = (Int(time) / 60) % 60
//        }
//        return String(format: "%0.2d:%0.2d",minutes,seconds)
//    }
//    
//    func getProgress()->Float{
//        var theCurrentTime = 0.0
//        var theCurrentDuration = 0.0
//        if let currentTime = Readingplayer.currentTime as? Double, duration = Readingplayer.duration as? Double {
//            theCurrentTime = currentTime
//            theCurrentDuration = duration
//        }
//        return Float(theCurrentTime / theCurrentDuration)
//    }
//    
//    override func viewDidLoad() {
//        //        Readingplayer.delegate = self
//        playButton.addTarget(self, action: "playFile", forControlEvents: UIControlEvents.TouchUpInside)
//        self.title = ""
//        self.edgesForExtendedLayout = UIRectEdge.None
//        let bottomBar = createBottomArticleListBar(self.view, playButton: playButton)
//        //        middleView.backgroundColor = UIColor.whiteColor()
//        middleView.backgroundColor = UIColor(red: 52.0/255.0, green: 170.0/255.0, blue: 220.0/255.0, alpha: 1.0)
//        self.view.addSubview(middleView)
//        middleView.addSubview(progressView)
//        middleView.snp_makeConstraints { (make) -> Void in
//            make.left.top.right.equalTo(self.view)
//            make.bottom.equalTo(bottomBar.snp_top)
//        }
//        
//        progressView.snp_makeConstraints { (make) -> Void in
//            //            make.left.right.bottom.equalTo(middleView)
//            make.center.equalTo(middleView)
//            make.height.width.equalTo(300)
//        }
//        getTrackURL(indexToListenAt)
//        
//        var error:NSError?
//        let folderExists = self.fileURL!.checkResourceIsReachableAndReturnError(&error)
//        if folderExists != true {
//            downloadFile()
//        } else {
//            do {
//                let Readingplayer = try AVAudioPlayer(contentsOfURL: self.fileURL)
//                self.Readingplayer = Readingplayer
//                self.Readingplayer.delegate = self
//            } catch {
//                print(error)
//            }
//        }
//    }
//    
//    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
//        playOrPause = false
//        playButton.setBackgroundImage(UIImage(named: "play-button"), forState: .Normal)
//    }
//    
//    override func viewWillDisappear(animated: Bool) {
//        playOrPause = false
//        progressView.animateProgressView()
//        if let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as? NSURL {
//            self.fileURL = directoryURL.URLByAppendingPathComponent("\(ReadingsListArray[indexToListenAt].uuid)")
//            directoryURL.URLByAppendingPathComponent("\(ReadingsListArray[indexToListenAt].uuid)")
//            do {
//                try NSFileManager.defaultManager().removeItemAtURL(fileURL)
//            } catch {
//                print(error)
//            }
//        }
//    }
//}