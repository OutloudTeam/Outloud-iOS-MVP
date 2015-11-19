////
////  ReadingsList.swift
////  OutloudMVP
////
////  Created by Frederik Lohner on 13/Nov/15.
////  Copyright © 2015 Outloud. All rights reserved.
////
//
//import Foundation
//import UIKit
//import SnapKit
////import AVFoundation
//import SwiftOverlays
//
//class ReadingsList: UIViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate {
//    
//    let listenContainer = UIButton()
//    let playButton = UIButton()
//    var refreshControl:UIRefreshControl!
//    func refresh(sender:AnyObject)
//    {
//        readingsListGet() { () -> () in
//            self.tableView.reloadData()
//            self.refreshControl.endRefreshing()
//        }
//    }
//    
//    //    func handleSingleTap(sender: UIButton) {
//    //        let alert: UIAlertView = UIAlertView()
//    //
//    //        alert.addButtonWithTitle("Listen")
//    //        alert.addButtonWithTitle("Record")
//    //        alert.delegate = self  // set the delegate here
//    //        alert.show()
//    //    }
//    //    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
//    //        alertView.buttonTitleAtIndex(buttonIndex)
//    //        print("\(buttonIndex) pressed")
//    //        if buttonIndex == 0 {
//    //            print("Listen was clicked")
//    //            SwiftOverlays.showBlockingWaitOverlayWithText("Loading!")
//    //            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//    //                SwiftOverlays.removeAllBlockingOverlays()
//    //                self.navigationController?.setViewControllers([ArticleListListen()], animated: true)
//    //            })
//    //        } else {
//    //            print("Record was clicked")
//    //            SwiftOverlays.showBlockingWaitOverlayWithText("Loading!")
//    //            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//    //                SwiftOverlays.removeAllBlockingOverlays()
//    //                self.navigationController?.setViewControllers([ArticleListRecord()], animated: true)
//    //            })
//    //        }
//    //    }
//    var tableView = UITableView(frame: CGRectMake(100, 100, 100, 100), style: .Grouped)
//    let playAllButton = UIButton(type: UIButtonType.System) as UIButton
//    
//    override func viewDidAppear(animated: Bool) {
//        self.navigationItem.titleView = createNavigationTitleViewArticleListListen(listenContainer , title: "Readings", category: "All", callback: { () -> Void in
//        })
//        self.navigationItem.titleView?.snp_makeConstraints(closure: { (make) -> Void in
//            make.width.equalTo(tableView.frame.width)
//            make.top.equalTo((self.navigationController?.view)!).offset(20)
//        })
//    }
//    
//    override func viewDidLoad() {
//        //        listenContainer.addTarget(self, action: "handleSingleTap:", forControlEvents: UIControlEvents.TouchUpInside)
//        
//        self.refreshControl = UIRefreshControl()
//        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
//        self.tableView.addSubview(refreshControl)
//        
//        self.title = ""
//        readingsListGet() { () -> () in
//            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
//                self.tableView.reloadData()
//            }
//        }
//        self.edgesForExtendedLayout = UIRectEdge.None
//        
//        let bottomBar = createBottomArticleListBar(self.view, playButton: playButton, playbackSpeedButton: playbackSpeedButton)
//        self.view.addSubview(tableView)
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.separatorStyle = .None
//        tableView.backgroundColor = UIColor.whiteColor()
//        tableView.separatorStyle = .None
//        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Test")
//        tableView.tableFooterView = UIView(frame: CGRect.zero)
//        
//        tableView.snp_makeConstraints { (make) -> Void in
//            make.left.right.top.equalTo(self.view)
//            make.bottom.equalTo(bottomBar.snp_top)
//        }
//    }
//    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return ReadingsListArray.count
//    }
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        return generateReadingListCell(tableView, indexPath: indexPath)
//    }
//    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 60
//    }
//    
//    //    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//    //        let articleBar = UIView()
//    //        self.view.addSubview(articleBar)
//    //        articleBar.backgroundColor = UIColor.whiteColor()
//    //        playAllButton.frame = CGRectMake(100, 50, 100, 50)
//    //        playAllButton.setBackgroundImage(UIImage(named: "play-all"), forState: .Normal)
//    //        playAllButton.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
//    //        articleBar.addSubview(playAllButton)
//    //        playAllButton.snp_makeConstraints { (make) -> Void in
//    //            make.height.equalTo(50)
//    //            make.width.equalTo(150)
//    //            make.centerX.equalTo(articleBar.snp_centerX)
//    //            make.centerY.equalTo(articleBar.snp_centerY)
//    //        }
//    //
//    //        return articleBar
//    //    }
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 1
//    }
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print("SELECTED")
//        indexToListenAt = indexPath.row
//        SwiftOverlays.showBlockingWaitOverlayWithText("Loading Reading!")
//        dispatch_async(dispatch_get_main_queue(), { () -> Void in
//            SwiftOverlays.removeAllBlockingOverlays()
//            self.navigationController?.pushViewController(ReadingsIndividualArticle(), animated: true)
//        })
//    }
//    
//    
//}