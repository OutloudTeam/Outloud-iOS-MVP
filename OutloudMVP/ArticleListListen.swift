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
    let progressIndicatorView = CircularLoaderView(frame: CGRectZero)
    var buttonIndex = 0
    let listenContainer = UIButton()
    let playButton = UIButton()
    let playbackSpeedButton = UIButton()
    var refreshControl:UIRefreshControl!
    let progressView = UIView()
    let imageLogo = UIImageView()
    
    lazy var articleTitle = UILabel()
    lazy var playOrPause = false
    lazy var Readingplayer = AVAudioPlayer()
    lazy var currentTrackIndex = -1
    lazy var tracks:[String] = [String]()
    var fileURL : NSURL!
    
    func refresh(sender:AnyObject)
    {
        articleListJSONGet(true, forceRefresh: true) { () -> () in
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
        currentTrackIndex = -1
    }
    
    override func viewDidLoad() {
        
        playButton.enabled = false
        playButton.setBackgroundImage(UIImage(named: "play-button"), forState: .Normal)
        playButton.setBackgroundImage(UIImage(named: "pause-button"), forState: .Selected)
        
        playbackSpeedButton.setBackgroundImage(UIImage(named: "speedModifier"), forState: .Normal)
        playbackSpeedButton.setBackgroundImage(UIImage(named: "edit-queue"), forState: .Selected)
        playbackSpeedButton.enabled = false
        
        self.navigationItem.titleView = createNavigationTitleViewArticleListListenSingleTitle(listenContainer, title: "Listen", callback: { () -> Void in
        })
        
        playButton.addTarget(self, action: "playFile", forControlEvents: UIControlEvents.TouchUpInside)
        listenContainer.addTarget(self, action: "handleSingleTap:", forControlEvents: UIControlEvents.TouchUpInside)
        playbackSpeedButton.addTarget(self, action: "changeSpeed", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        self.title = ""
        readingsListGet { () -> () in
            articleListJSONGet(true, forceRefresh: false) { () -> () in
                dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                    self.tableView.reloadData()
                }
            }
        }
        self.edgesForExtendedLayout = UIRectEdge.None
        
        let bottomBar = createBottomArticleListBar(self.view, playButton: playButton, playbackSpeedButton: playbackSpeedButton)
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
        self.view.addSubview(progressView)
        
        
        progressView.addSubview(imageLogo)
        imageLogo.image = UIImage(named: "parrot-load")
        progressView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self.view)
            make.height.width.equalTo(200)
        }
        imageLogo.snp_makeConstraints { (make) -> Void in
            make.left.right.top.bottom.equalTo(progressView)
        }
        
        progressView.addSubview(progressIndicatorView)
        progressIndicatorView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(imageLogo)
            //            make.width.height.equalTo(imageLogo)
        }
        progressIndicatorView.backgroundColor = redColor
        progressIndicatorView.frame = progressView.bounds
        progressIndicatorView.maskView?.bounds = progressView.bounds
        progressIndicatorView.autoresizingMask = .FlexibleWidth
        progressIndicatorView.autoresizingMask = .FlexibleHeight
        self.progressIndicatorView.progress = 0.0
        progressIndicatorView.circlePathLayer.removeFromSuperlayer()
        progressView.layer.mask = progressIndicatorView.circlePathLayer
        progressView.layer.mask?.bounds = imageLogo.bounds
        self.progressView.alpha = 0
        //        self.progressIndicatorView.reveal()
        
        bottomBar.addSubview(articleTitle)
        articleTitle.text = ""
        articleTitle.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(bottomBar)
            make.left.equalTo(bottomBar).offset(10)
            make.top.bottom.equalTo(bottomBar)
            make.right.equalTo(playbackSpeedButton.snp_left).offset(-12)
        }
        
        //        progressIndicatorView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArticleListArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = generateArticleListListenCell(tableView, indexPath: indexPath)
        cell.backgroundColor = UIColor.whiteColor()
        if currentTrackIndex == indexPath.row {
            cell.backgroundColor = yellowColor.colorWithAlphaComponent(0.1)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var cellHeight : CGFloat = 0
        if (ArticleListArray[indexPath.row].title != "") {
            cellHeight = heightForJustifiedView(ArticleListArray[indexPath.row].title!, font: articleListTileFont, width: (tableView.frame.width - 115), lineSpace: 0) + heightForView(ArticleListArray[indexPath.row].abstract!, font: articleListAbstractFont, width: (tableView.frame.width - 115))
        } else {
            cellHeight = heightForJustifiedView("Title is being processed!", font: articleListTileFont, width: (tableView.frame.width - 115), lineSpace: 0) + heightForView("We are currently processing this recording!  Please have patience with us!", font: articleListAbstractFont, width: (tableView.frame.width - 115))
        }
        //Height for title and abstract + height from top + space between title and abstract + space from abstract and height for rating + BOTTOM ROW FOR NYTIMES AND STUFF
        //        return cellHeight + 25 + 5 + 25 + 20 + 20
        return cellHeight + 25 + 5 + 25 + 20
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if fileURL != nil {
            self.Readingplayer.stop()
        }
        playOrPause = false
        playButton.enabled = false
        playButton.selected = false
        playbackSpeedButton.selected = false
        articleTitle.text = ArticleListArray[indexPath.row].title
        articleTitle.textColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
        transformIntoJustified(articleTitle, lineSpace: 1)
        
        getTrackURL(indexPath)
        
        var error:NSError?
        currentTrackIndex = indexPath.row
        tableView.reloadData()
        let folderExists = self.fileURL!.checkResourceIsReachableAndReturnError(&error)
        if folderExists != true {
            downloadFile(indexPath)
        } else {
            do {
                let Readingplayer = try AVAudioPlayer(contentsOfURL: self.fileURL)
                
                self.Readingplayer = Readingplayer
                self.Readingplayer.enableRate = true
                self.Readingplayer.delegate = self
                self.Readingplayer.play()
                playButton.selected = true
                playButton.enabled = true
                playbackSpeedButton.enabled = true
            } catch {
                print(error)
            }
        }
    }
    
    //CODE FOR PLAYING FILES
    func downloadFile(indexPath: NSIndexPath) {
        self.progressView.alpha = 100
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
                    let progress = (Double(totalBytesRead) / Double(totalBytesExpectedToRead)) * 1
                    self.progressIndicatorView.progress = CGFloat(progress)
                    //                    SwiftOverlays.showBlockingWaitOverlayWithText("Downloading Article: \(Int(progress))%!")
                    print("Total bytes read on main queue: \(progress)")
                }
            }
            .response { _, _, _, error in
                if let error = error {
                    print("Failed with error: \(error)")
                    //                    SwiftOverlays.removeAllBlockingOverlays()
                } else {
                    print("Downloaded file successfully")
                    self.Readingplayer = AVAudioPlayer()
                    //                    SwiftOverlays.removeAllBlockingOverlays()
                    do {
                        let Readingplayer = try AVAudioPlayer(contentsOfURL: self.fileURL)
                        self.Readingplayer = Readingplayer
                        self.Readingplayer.delegate = self
                        self.Readingplayer.enableRate = true
                        self.Readingplayer.play()
                        self.playButton.selected = true
                        self.playButton.enabled = true
                        self.playbackSpeedButton.enabled = true
                        UIView.animateWithDuration(1.0, animations: {
                            self.progressView.alpha = 0
                        })
                    } catch {
                        print(error)
                    }
                    self.progressIndicatorView.progress = 0
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
        if (playButton.selected == true) {
            self.Readingplayer.play()
            
            playOrPause = true
            //            playButton.setBackgroundImage(UIImage(named: "pause-button"), forState: .Normal)
        } else {
            self.Readingplayer.pause()
            playOrPause = false
            //            playButton.setBackgroundImage(UIImage(named: "play-button"), forState: .Normal)
        }
    }
    
    func changeSpeed() {
        playbackSpeedButton.selected = !playbackSpeedButton.selected
        if playbackSpeedButton.selected == true {
            self.Readingplayer.rate = 1.3
        } else {
            self.Readingplayer.rate = 1.0
        }
        
    }
    
}