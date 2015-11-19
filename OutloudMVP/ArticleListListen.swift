//
//  ArticleList.swift
//  OutloudMVP
//
//  Created by Frederik Lohner on 10/Oct/15.
//  Copyright © 2015 Outloud. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import AVFoundation
import SwiftOverlays
import Alamofire

class ArticleListListen: UIViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, AVAudioPlayerDelegate {
    
    var buttonIndex = 0
    let listenContainer = UIButton()
    let playButton = UIButton()
    var refreshControl:UIRefreshControl!
    
    lazy var playOrPause = false
    lazy var Readingplayer = AVAudioPlayer()
    lazy var currentTrackIndex = 0
    lazy var tracks:[String] = [String]()
    var fileURL : NSURL!
    
    func refresh(sender:AnyObject)
    {
        articleListJSONGet(true) { () -> () in
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func handleSingleTap(sender: UIButton) {
        //        let alert: UIAlertView = UIAlertView()
        //
        //        alert.addButtonWithTitle("Listen")
        //        alert.addButtonWithTitle("Record")
        //        alert.delegate = self  // set the delegate here
        //        alert.show()
        print("Record was clicked")
        SwiftOverlays.showBlockingWaitOverlayWithText("Loading!")
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            SwiftOverlays.removeAllBlockingOverlays()
            self.navigationController?.setViewControllers([ArticleListRecord()], animated: true)
        })
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        alertView.buttonTitleAtIndex(buttonIndex)
        print("\(buttonIndex) pressed")
        if buttonIndex == 0 {
            print("Listen was clicked")
            SwiftOverlays.showBlockingWaitOverlayWithText("Loading!")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                SwiftOverlays.removeAllBlockingOverlays()
                self.navigationController?.setViewControllers([ArticleListListen()], animated: true)
            })
        } else {
            print("Record was clicked")
            SwiftOverlays.showBlockingWaitOverlayWithText("Loading!")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                SwiftOverlays.removeAllBlockingOverlays()
                self.navigationController?.setViewControllers([ArticleListRecord()], animated: true)
            })
        }
    }
    var tableView = UITableView(frame: CGRectMake(100, 100, 100, 100), style: .Grouped)
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        playButton.enabled = false
        playButton.setBackgroundImage(UIImage(named: "play-button"), forState: .Normal)
        playButton.setBackgroundImage(UIImage(named: "pause-button"), forState: .Selected)
        
        self.navigationItem.titleView = createNavigationTitleViewArticleListListenSingleTitle(listenContainer, title: "Listen", callback: { () -> Void in
        })
        
        playButton.addTarget(self, action: "playFile", forControlEvents: UIControlEvents.TouchUpInside)
        listenContainer.addTarget(self, action: "handleSingleTap:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        self.title = ""
        readingsListGet { () -> () in
            
            articleListJSONGet(true) { () -> () in
                dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                    self.tableView.reloadData()
                }
            }
        }
        self.edgesForExtendedLayout = UIRectEdge.None
        
        let bottomBar = createBottomArticleListBar(self.view, playButton: playButton)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.whiteColor()
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
        return ArticleListArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return generateArticleListListenCell(tableView, indexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellHeight = heightForJustifiedView(ArticleListArray[indexPath.row].title!, font: articleListTileFont, width: (tableView.frame.width - 115), lineSpace: 0) + heightForView(ArticleListArray[indexPath.row].abstract!, font: articleListAbstractFont, width: (tableView.frame.width - 115))
        //Height for title and abstract + height from top + space between title and abstract + space from abstract and height for rating + BOTTOM ROW FOR NYTIMES AND STUFF
        //        return cellHeight + 25 + 5 + 25 + 20 + 20
        return cellHeight + 25 + 5 + 25 + 20
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if let reader = Readingplayer {
//            if reader.playing == true {
//                Readingplayer.stop()
//            }
//        }
        playOrPause = false
        playButton.enabled = false
        playButton.setBackgroundImage(UIImage(named: "play-button"), forState: .Normal)
        
        getTrackURL(indexPath)
        
        var error:NSError?
        let folderExists = self.fileURL!.checkResourceIsReachableAndReturnError(&error)
        if folderExists != true {
            downloadFile(indexPath)
        } else {
            do {
                let Readingplayer = try AVAudioPlayer(contentsOfURL: self.fileURL)
                self.Readingplayer = Readingplayer
                self.Readingplayer.delegate = self
                playButton.enabled = true
            } catch {
                print(error)
            }
        }
    }
    
    
    //CODE FOR PLAYING FILES
    func downloadFile(indexPath: NSIndexPath) {
        var url = ""
        let destination: (NSURL, NSHTTPURLResponse) -> (NSURL) = {
            (temporaryURL, response) in
            
            if let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as? NSURL {
                self.fileURL = directoryURL.URLByAppendingPathComponent("\(ArticleListArray[indexPath.row].uuid)")
                return directoryURL.URLByAppendingPathComponent("\(ArticleListArray[indexPath.row].uuid)")
            }
            return temporaryURL
        }
        
        for (var i = 0; i<ReadingsListArray.count;i++) {
            if(ReadingsListArray[i].articleID == ArticleListArray[indexPath.row].uuid) {
                url = ReadingsListArray[i].url!
            }
        }
        if url == "" {
            return
        }
        Alamofire.download(.GET, url, destination: destination)
            .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
                dispatch_async(dispatch_get_main_queue()) {
                    let progress = (Double(totalBytesRead) / Double(totalBytesExpectedToRead)) * 100
                    SwiftOverlays.showBlockingWaitOverlayWithText("Downloading Article: \(Int(progress))%!")
                    print("Total bytes read on main queue: \(progress)")
                }
            }
            .response { _, _, _, error in
                if let error = error {
                    print("Failed with error: \(error)")
                    SwiftOverlays.removeAllBlockingOverlays()
                } else {
                    print("Downloaded file successfully")
                    self.Readingplayer = AVAudioPlayer()
                    SwiftOverlays.removeAllBlockingOverlays()
                    do {
                        let Readingplayer = try AVAudioPlayer(contentsOfURL: self.fileURL)
                        self.Readingplayer = Readingplayer
                        self.Readingplayer.delegate = self
                        self.playButton.enabled = true
                    } catch {
                        print(error)
                    }
                }
        }
    }
    
    func getTrackURL(indexPath: NSIndexPath) {
        if let directoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as? NSURL {
            fileURL = directoryURL.URLByAppendingPathComponent("\(ArticleListArray[indexPath.row].uuid)")
            directoryURL.URLByAppendingPathComponent("\(ArticleListArray[indexPath.row].uuid)")
        }
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        playOrPause = false
        playButton.setBackgroundImage(UIImage(named: "play-button"), forState: .Normal)
    }
    
    func playFile() {
        playButton.selected = !playButton.selected
        if (playOrPause == false) {
            self.Readingplayer.play()
            
            playOrPause = true
//            playButton.setBackgroundImage(UIImage(named: "pause-button"), forState: .Normal)
        } else {
            self.Readingplayer.pause()
            playOrPause = false
//            playButton.setBackgroundImage(UIImage(named: "play-button"), forState: .Normal)
        }
    }
    
}