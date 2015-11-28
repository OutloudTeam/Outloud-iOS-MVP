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
    let titleView = UIView()
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
        navigationController?.navigationBarHidden = true
    }
    
    func popView() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        navigationController?.navigationBarHidden = true
        self.title = ""
        
        let longpress = UILongPressGestureRecognizer(target: self, action: "longPressGestureRecognized:")
        tableView.addGestureRecognizer(longpress)
        longpress.minimumPressDuration = 0.25
        
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.navigationItem.titleView = createNavigationTitleViewArticleDetail(false, title: "Hold a paragraph to start recording!", callback: { () -> Void in
        })
        
        let title = UILabel()
        let sepBar = UIView()
        let backButton = UIButton()
        
        title.text = "Hold a paragraph to start recording!"
        title.textColor = redColor
        title.textAlignment = .Center
        
        sepBar.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.15)
        
        backButton.setBackgroundImage(UIImage(named: "back"), forState: UIControlState.Normal)
//        backButton.setTitle("<", forState: UIControlState.Normal)
        backButton.addTarget(self, action: "popView", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(tableView)
        self.view.addSubview(titleView)
        titleView.addSubview(title)
        titleView.addSubview(sepBar)
        titleView.addSubview(backButton)
        
        tableView.backgroundColor = backgroundColorAll
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Test")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.view.backgroundColor = UIColor.whiteColor()
        titleView.snp_makeConstraints { (make) -> Void in
            make.right.left.equalTo(self.view)
            make.top.equalTo(self.view).offset(20)
            make.height.equalTo(44)
        }
        tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(titleView.snp_bottom)
            make.left.right.bottom.equalTo(self.view)
            //            make.bottom.equalTo(bottomBar.snp_top)
        }
        title.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(titleView.snp_left).offset(10)
            make.right.equalTo(titleView).offset(-10)
            make.centerY.equalTo(titleView)
        }
        sepBar.snp_makeConstraints { (make) -> Void in
            make.left.right.bottom.equalTo(titleView)
            make.height.equalTo(0.5)
        }
        backButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(titleView)
            make.centerY.equalTo(titleView)
            make.height.equalTo(40)
            
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FullArticleContentArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return generateRecordingArticleCell(tableView, indexPath: indexPath, cellToRecordAt: cellToRecordAt)
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellHeight = heightForJustifiedView(FullArticleContentArray[indexPath.row].text!, font: recordArticleParagraphFont, width: (tableView.frame.width-60), lineSpace: 1)
        return cellHeight + 20
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return generateRecordingHeaderCell(tableView)
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let titleHeight = heightForJustifiedView(ArticleDetailArray[0].title!, font: recordArticleTitleFont, width: (tableView.frame.width - 60), lineSpace: 3)
        let authorHeight = heightForJustifiedView(ArticleDetailArray[0].author!, font: authorNameFont, width: (tableView.frame.width-60), lineSpace: 3)
        let articleHeight = heightForView("Placeholder.com", font: articleLinkFont, width: (tableView.frame.width - 60))
        //cell height is dynamically genrated then the constraint values are added to it
        return titleHeight + authorHeight + articleHeight + 67
    }
    
    //MARK: - Gesture recognizer for long press, will display a alert
    func longPressGestureRecognized(gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let locationInView = longPress.locationInView(tableView)
        let indexPath = tableView.indexPathForRowAtPoint(locationInView)
        if let cellToRecordAtProtector = indexPath?.row {
            //            if (gestureRecognizer.state == UIGestureRecognizerState.Ended) {
            //                print(cellToRecordAtProtector)
            //                dispatch_async(dispatch_get_main_queue(), { () -> Void in
            //                    ParagraphCount = cellToRecordAtProtector
            //                    self.cellToRecordAt = -1
            //                    self.navigationController?.pushViewController(RecordIndividualParagraph(), animated: true)
            //                })
            //            } else if (gestureRecognizer.state == UIGestureRecognizerState.Changed) {
            //                cellToRecordAt = cellToRecordAtProtector
            //                tableView.reloadData()
            //            } else
            if (gestureRecognizer.state == UIGestureRecognizerState.Began) {
                cellToRecordAt = cellToRecordAtProtector
                tableView.reloadData()
                print(cellToRecordAtProtector)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    ParagraphCount = cellToRecordAtProtector
                    self.cellToRecordAt = -1
                    self.navigationController?.pushViewController(RecordIndividualParagraph(), animated: true)
                })
            }
        }
    }
}
