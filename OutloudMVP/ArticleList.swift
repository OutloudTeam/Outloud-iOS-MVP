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

class ArticleList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
        self.navigationItem.titleView = createNavigationTitleViewArticleList("Listen", category: "Popular", callback: { () -> Void in
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
        self.navigationItem.titleView = createNavigationTitleViewArticleList("Listen", category: "Popular", callback: { () -> Void in
        })
        
        
        let bottomBar = createBottomArticleListBar(self.view)
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
        return generateArticleListCell(tableView, indexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellHeight = heightForJustifiedView(ArticleListArray[indexPath.row].title!, font: articleListTileFont, width: (tableView.frame.width - 115), lineSpace: 0) + heightForView(ArticleListArray[indexPath.row].abstract!, font: articleListAbstractFont, width: (tableView.frame.width - 115))
        //Height for title and abstract + height from top + space between title and abstract + space from abstract and height for rating + BOTTOM ROW FOR NYTIMES AND STUFF
        return cellHeight + 25 + 5 + 25 + 20 + 20
    }
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let articleBar = UIView()
//        self.view.addSubview(articleBar)
//        articleBar.backgroundColor = UIColor.whiteColor()
//        playAllButton.frame = CGRectMake(100, 50, 100, 50)
//        playAllButton.setBackgroundImage(UIImage(named: "play-all"), forState: .Normal)
//        playAllButton.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
//        articleBar.addSubview(playAllButton)
//        playAllButton.snp_makeConstraints { (make) -> Void in
//            make.height.equalTo(50)
//            make.width.equalTo(150)
//            make.centerX.equalTo(articleBar.snp_centerX)
//            make.centerY.equalTo(articleBar.snp_centerY)
//        }
//        
//        return articleBar
//    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        SwiftOverlays.showBlockingWaitOverlayWithText("Loading!")
        articleJSONGet(&articleDetailDictionary, articleID: ArticleListArray[indexPath.row].uuid!) { () -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                SwiftOverlays.removeAllBlockingOverlays()
                //                self.navigationController?.pushViewController(ArticleDetail(), animated: true)
                self.navigationController?.pushViewController(ArticleDetail(), animated: true)
            })
        }
    }
    
}