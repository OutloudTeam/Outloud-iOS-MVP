//
//  ArticleListRecord.swift
//  OutloudMVP
//
//  Created by Frederik Lohner on 3/Nov/15.
//  Copyright © 2015 Outloud. All rights reserved.
//


import Foundation
import UIKit
import SnapKit
import AVFoundation
import SwiftOverlays

class ArticleListRecord: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let listenContainer = UIButton()
    var refreshControl:UIRefreshControl!
    func refresh(sender:AnyObject)
    {
        articleListJSONGet(false, forceRefresh: true) { () -> () in
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    var tableView = UITableView(frame: CGRectMake(100, 100, 100, 100), style: .Grouped)
    let playAllButton = UIButton(type: UIButtonType.System) as UIButton
    
    
    override func viewDidAppear(animated: Bool) {
    }
    func handleSingleTap(sender: UIButton) {
        //        let alert: UIAlertView = UIAlertView()
        //
        //        let yesBut = alert.addButtonWithTitle("Listen")
        //        let noBut = alert.addButtonWithTitle("Record")
        //        alert.delegate = self  // set the delegate here
        //        alert.show()
        print("Listen was clicked")
        SwiftOverlays.showBlockingWaitOverlayWithText("Loading!")
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            SwiftOverlays.removeAllBlockingOverlays()
            self.navigationController?.setViewControllers([ArticleListListen()], animated: true)
        })
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let buttonTitle = alertView.buttonTitleAtIndex(buttonIndex)
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
    override func viewDidLoad() {
        self.navigationItem.titleView = createNavigationTitleViewArticleListRecordSingleTitle(listenContainer, title: "Record", callback: { () -> Void in
        })
        self.navigationItem.setLeftBarButtonItem(nil, animated: true)
        
        listenContainer.addTarget(self, action: "handleSingleTap:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        self.title = ""
        articleListJSONGet(false, forceRefresh: false) { () -> () in
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.tableView.reloadData()
            }
        }
        self.edgesForExtendedLayout = UIRectEdge.None
        
        
        
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorStyle = .None
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Test")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        tableView.snp_makeConstraints { (make) -> Void in
            make.left.bottom.right.top.equalTo(self.view)
        }
        
        if ArticleListArray.count == 0 {
            tableView.hidden = true
            let noResultsView = UIView()
            let noResultsLabel = UILabel()
            
            self.view.addSubview(noResultsView)
            noResultsView.addSubview(noResultsLabel)
            
            noResultsView.backgroundColor = UIColor.blackColor()
            noResultsLabel.text = "No internet found :("
            noResultsLabel.textColor = UIColor.whiteColor()
            
            noResultsView.snp_makeConstraints(closure: { (make) -> Void in
                make.left.top.bottom.right.equalTo(self.view)
            })
            noResultsLabel.snp_makeConstraints(closure: { (make) -> Void in
                make.center.equalTo(noResultsView)
            })
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ArticleListArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return generateArticleListRecordCell(tableView, indexPath: indexPath)
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
        if(indexPath.row != 0) {
            SwiftOverlays.showBlockingWaitOverlayWithText("Loading!")
            articleJSONGet(&articleDetailDictionary, articleID: ArticleListArray[indexPath.row].uuid!) { () -> () in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    SwiftOverlays.removeAllBlockingOverlays()
                    //                self.navigationController?.pushViewController(ArticleDetail(), animated: true)
                    CurrentArticleUuid = ArticleListArray[indexPath.row].uuid
                    self.navigationController?.pushViewController(RecordDetails(), animated: true)
                })
            }
          //HERE WE GO TO WEB VIEW
        } else {
            self.navigationController?.pushViewController(CustomRecordWebView(), animated: true)
        }
    }
    
}