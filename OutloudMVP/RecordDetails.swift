//
//  RecordDetails.swift
//  OutloudMVP
//
//  Created by Frederik Lohner on 27/Oct/15.
//  Copyright © 2015 Outloud. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import AVFoundation


class RecordDetails: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //BUTTONS
    let playButton = UIButton(type: UIButtonType.System) as UIButton
    let skipBackButton = UIButton(type: UIButtonType.System) as UIButton
    let skipForwardButton =  UIButton(type: UIButtonType.System) as UIButton
    let upvoteButton = UIButton(type: UIButtonType.System) as UIButton
    let downvoteButton = UIButton(type: UIButtonType.System) as UIButton
    let shareButton = UIButton(type: UIButtonType.System) as UIButton
    
    var cellToRecordAt = -1
    let voteCount = UILabel()
    var intVoteCount = 1023
    var tableView = UITableView(frame: CGRectMake(100, 100, 100, 100), style: .Grouped)
    var scrollView: UIScrollView!
    
    override func viewDidAppear(animated: Bool) {
    }
    func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        let locationInView = longPress.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(locationInView)
        if let cellToRecordAtProtector = indexPath?.row {
            cellToRecordAt = cellToRecordAtProtector
            tableView.reloadData()
        }
        
    }
    override func viewDidLoad() {
        let longpress = UILongPressGestureRecognizer(target: self, action: "longPressGestureRecognized:")
        tableView.addGestureRecognizer(longpress)
        longpress.minimumPressDuration = 2
        
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.navigationItem.titleView = createNavigationTitleViewArticleDetail("Read", callback: { () -> Void in
        })
        
        let bottomBar = createBottomRecordDetailBar(self.view)
        self.view.addSubview(tableView)
        tableView.backgroundColor = UIColor.whiteColor()
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
        //         return FullArticleContentArray.count
        return 10
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let paragraph = UILabel()
        cell.addSubview(paragraph)
        paragraph.text = "PLACE HOLDINGSGKLSDGJ :SLKDFJ S:LDFJ :LSUIOEJF :LSKJF (EIL:SKFJ IOEJ"
        //        paragraph.text = FullArticleContentArray[indexPath.row].text
        paragraph.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraph.numberOfLines = 0
        paragraph.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(cell.snp_left).offset(30)
            make.right.equalTo(cell.snp_right).offset(-30)
            make.top.equalTo(cell.snp_top).offset(5)
        }
        let fontTest = UIFont(name: "Helvetica", size: 14.0)
        paragraph.font = fontTest
        paragraph.textColor = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1.0)
        
        if(cellToRecordAt == indexPath.row){
            paragraph.textColor = UIColor.blackColor()
            let fontTest = UIFont(name: "Helvetica", size: 14.0)
            paragraph.font = fontTest
        }
        //        cell.selectionStyle = .None
        
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let paragraph = UILabel()
        //        paragraph.text = ArticleDetailArray[0].fullContent[indexPath.row].text
        paragraph.text = "PLACE HOLDINGSGKLSDGJ :SLKDFJ S:LDFJ :LSUIOEJF :LSKJF (EIL:SKFJ IOEJ"
        let fontTest = UIFont(name: "Helvetica", size: 14.0)
        paragraph.font = fontTest
        var cellHeight = heightForView(paragraph.text!, font: fontTest!, width: (tableView.frame.width - 60))
        cellHeight = cellHeight + 10
        return cellHeight
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let authorName = UILabel()
        
        self.view.addSubview(headerView)
        headerView.addSubview(authorName)
        
        headerView.backgroundColor = UIColor.whiteColor()
        let articleTitle = UILabel()
        articleTitle.text = "A Placebo Can Make You Run Faster"
        articleTitle.font = UIFont(name: ".SFUIText-Light", size: 24)
        articleTitle.textAlignment = .Center
        articleTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        articleTitle.numberOfLines = 0
        
        articleTitle.textColor = black
        headerView.addSubview(articleTitle)
        articleTitle.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(headerView).offset(30)
            make.top.equalTo(headerView).offset(5)
            make.right.equalTo(headerView.snp_right).offset(-30)
        }
        //
        authorName.adjustsFontSizeToFitWidth = true
        authorName.text = "by PlaceHolder"
        authorName.font = UIFont(name: ".SFUIText-Light", size: 12)
        
        authorName.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(articleTitle.snp_bottom).offset(5)
            make.left.equalTo(articleTitle.snp_left).offset(5)
            make.right.equalTo(articleTitle.snp_right).offset(-5)
        }
        let articleLink = UILabel()
        //        guard let fullURL = ArticleDetailArray[0].url else {
        //            articleLink.text = "Not Found"
        //            return articleBar
        //        }
        //        let fullURLArray = fullURL.characters.split{$0 == "."}.map(String.init)
        //        articleLink.text = fullURLArray[1]
        articleLink.text = "Placeholder.com"
        articleLink.textColor = transparentBlack
        articleLink.font = UIFont(name: ".SFUIText-Light", size: 10)
        headerView.addSubview(articleLink)
        articleLink.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(authorName.snp_left)
            make.top.equalTo(authorName.snp_bottom).offset(2)
        }
        let separatorBar = UIView()
        headerView.addSubview(separatorBar)
        separatorBar.backgroundColor = darkRed
        separatorBar.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(1)
            make.bottom.equalTo(headerView.snp_bottom)
            make.left.equalTo(headerView.snp_left).offset(50)
            make.right.equalTo(headerView.snp_right).offset(-50)
        }
        return headerView
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let cellHeight = heightForView("A Placebo Can Make You Run Faster", font: UIFont(name: ".SFUIText-Light", size: 24)!, width: (tableView.frame.width - 60))
        return cellHeight + 40
        //        return 20
    }
}
