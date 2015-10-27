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
    var tableView = UITableView(frame: CGRectMake(100, 100, 100, 100), style: .Grouped)
    let playAllButton = UIButton(type: UIButtonType.System) as UIButton
    
    override func viewDidLoad() {
        self.title = ""
        articleListJSONGet { () -> () in
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.tableView.reloadData()
            }
        }
        self.edgesForExtendedLayout = UIRectEdge.None
        self.navigationItem.titleView = createNavigationTitleViewArticleList("Listen", callback: { () -> Void in
        })
        let bottomBar = createBottomArticleListBar(self.view)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
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
        let articleTitle = UILabel()
        let articleAbstract = UILabel()
        articleTitle.text = ArticleListArray[indexPath.row].title
        articleAbstract.text = ArticleListArray[indexPath.row].abstract
        
        let fontTest = UIFont(name: "Helvetica", size: 14.0)
        articleTitle.font = fontTest
        articleAbstract.font = fontTest
        
        var cellHeight = heightForView(articleTitle.text!, font: fontTest!, width: (tableView.frame.width - 75)) + heightForView(articleAbstract.text!, font: articleAbstractFont!, width: (tableView.frame.width - 45))
        cellHeight = cellHeight + 35 + 15 + 20
        return cellHeight
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let articleBar = UIView()
        self.view.addSubview(articleBar)
        articleBar.backgroundColor = UIColor.whiteColor()
        playAllButton.frame = CGRectMake(100, 50, 100, 50)
        playAllButton.setBackgroundImage(UIImage(named: "play-all"), forState: .Normal)
        playAllButton.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0)
        articleBar.addSubview(playAllButton)
        playAllButton.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.width.equalTo(150)
            make.centerX.equalTo(articleBar.snp_centerX)
            make.centerY.equalTo(articleBar.snp_centerY)
        }
        
        return articleBar
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        SwiftOverlays.showBlockingWaitOverlayWithText("Loading!")
        articleJSONGet(&articleDetailDictionary, articleID: ArticleListArray[indexPath.row].uuid!) { () -> () in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                SwiftOverlays.removeAllBlockingOverlays()
                self.navigationController?.pushViewController(ArticleDetail(), animated: true)
            })
        }
    }
    
}