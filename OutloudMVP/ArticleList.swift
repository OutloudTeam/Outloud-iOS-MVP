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

class ArticleList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView = UITableView()
    let playAllButton = UIButton(type: UIButtonType.System) as UIButton
    var indexToColor = -1
    
    override func viewDidLoad() {
        articleListJSONGet { () -> () in
            dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                self.tableView.reloadData()
            }
        }
        self.edgesForExtendedLayout = UIRectEdge.None
        self.navigationItem.titleView = createNavigationTitleView("Listen", callback: { () -> Void in
        })
        let bottomBar = createBottomArticleListBar(self.view)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
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
        let cell = UITableViewCell()
        let articleTitle = UILabel()
        let articleAbstract = UILabel()
        let separatorBar = UIView()
        
        cell.addSubview(articleTitle)
        cell.addSubview(articleAbstract)
        cell.addSubview(separatorBar)
        
        articleTitle.text = ArticleListArray[indexPath.row].title
        articleAbstract.text = ArticleListArray[indexPath.row].abstract
        
        articleTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        articleAbstract.lineBreakMode = NSLineBreakMode.ByWordWrapping

        articleTitle.numberOfLines = 0
        articleAbstract.numberOfLines = 0
        
        articleTitle.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(cell.snp_left).offset(30)
            make.right.equalTo(cell.snp_right).offset(-30)
            make.top.equalTo(cell.snp_top).offset(25)
        }
        articleAbstract.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(articleTitle.snp_left)
            make.right.equalTo(articleTitle.snp_right)
            make.top.equalTo(articleTitle.snp_bottom).offset(3)
        }
        let fontTest = UIFont(name: "Helvetica", size: 14.0)
        articleTitle.font = fontTest
        articleTitle.textColor = UIColor.redColor()
        articleAbstract.font = articleAbstractFont
        
//        cell.userInteractionEnabled = false
        
        separatorBar.backgroundColor = UIColor.blackColor()
        separatorBar.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(cell.snp_centerX)
            make.left.equalTo(cell.snp_left).offset(90)
            make.right.equalTo(cell.snp_right).offset(-90)
            make.height.equalTo(1)
            make.bottom.equalTo(cell.snp_bottom).offset(2)
        }

        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let articleTitle = UILabel()
        let articleAbstract = UILabel()
        articleTitle.text = ArticleListArray[indexPath.row].title
        articleAbstract.text = ArticleListArray[indexPath.row].abstract
        
        let fontTest = UIFont(name: "Helvetica", size: 14.0)
        articleTitle.font = fontTest
        articleAbstract.font = fontTest
        
        var cellHeight = heightForView(articleTitle.text!, font: fontTest!, width: (tableView.frame.width - 60)) + heightForView(articleAbstract.text!, font: articleAbstractFont!, width: (tableView.frame.width - 60))
        cellHeight = cellHeight + 35 + 15
        return cellHeight
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let articleBar = UIView()
        self.view.addSubview(articleBar)
        articleBar.backgroundColor = UIColor.whiteColor()
        playAllButton.frame = CGRectMake(50, 50, 50, 50)
        playAllButton.backgroundColor = UIColor.blackColor()
        articleBar.addSubview(playAllButton)
        playAllButton.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(50)
            make.centerX.equalTo(articleBar.snp_centerX)
            make.centerY.equalTo(articleBar.snp_centerY)
        }

        return articleBar
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 75
    }

}