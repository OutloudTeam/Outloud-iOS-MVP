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
    
    var refreshControl:UIRefreshControl!
    func refresh(sender:AnyObject)
    {
        articleListJSONGet { () -> () in
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    var tableView = UITableView(frame: CGRectMake(100, 100, 100, 100), style: .Grouped)
    let playAllButton = UIButton(type: UIButtonType.System) as UIButton
    
    override func viewDidAppear(animated: Bool) {
        self.navigationItem.titleView = createNavigationTitleViewArticleListRecord(self.parentViewController!, title: "Record", category: "Trending", callback: { () -> Void in
        })
        self.navigationItem.titleView?.snp_makeConstraints(closure: { (make) -> Void in
            make.width.equalTo(tableView.frame.width)
            make.top.equalTo((self.navigationController?.view)!).offset(20)
            
        })
    }
    
    override func viewDidLoad() {
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        self.title = ""
        articleListJSONGet { () -> () in
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
        return cellHeight + 25 + 5 + 25 + 20 + 20
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        SwiftOverlays.showBlockingWaitOverlayWithText("Loading!")
        articleJSONGet(&articleDetailDictionary, articleID: ArticleListArray[indexPath.row].uuid!) { () -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                SwiftOverlays.removeAllBlockingOverlays()
                //                self.navigationController?.pushViewController(ArticleDetail(), animated: true)
                self.navigationController?.pushViewController(RecordDetails(), animated: true)
            })
        }
    }
    
}