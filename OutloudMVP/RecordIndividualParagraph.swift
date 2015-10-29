//
//  RecordIndividualParagraph.swift
//  OutloudMVP
//
//  Created by Frederik Lohner on 27/Oct/15.
//  Copyright © 2015 Outloud. All rights reserved.
//

import Foundation
import UIKit

class RecordIndividualParagraph: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let backwardButton = UIButton(type: UIButtonType.System) as UIButton
    let forwardButton = UIButton(type: UIButtonType.System) as UIButton
    var tableView = UITableView(frame: CGRectMake(100, 100, 100, 100), style: .Grouped)
    let completionBar = UIView()
    var completionWidth : CGFloat!
    func forwardParagraph() {
        backwardButton.hidden = false
        if(ParagraphCount < FullArticleContentArray.count-1) {
            if (ParagraphCount+1 == FullArticleContentArray.count-1) {
                forwardButton.hidden = true
            } else {
                forwardButton.hidden = false
            }
            ParagraphCount++
            self.navigationItem.titleView = createNavigationTitleViewArticleRecordParagraph("Pargraph \(ParagraphCount+1) / \(FullArticleContentArray.count)", callback: { () -> Void in
            })
            tableView.reloadData()
            completionWidth = self.view.frame.width * (CGFloat(ParagraphCount+1) / CGFloat(FullArticleContentArray.count))
            completionBar.snp_updateConstraints(closure: { (make) -> Void in
                make.width.equalTo(completionWidth)
            })
        }
    }
    func backwardParagraph() {
        forwardButton.hidden = false
        if(ParagraphCount > 0) {
            if (ParagraphCount-1 == 0) {
                backwardButton.hidden = true
            } else {
                backwardButton.hidden = false
            }
            ParagraphCount--
            self.navigationItem.titleView = createNavigationTitleViewArticleRecordParagraph("Pargraph \(ParagraphCount+1) / \(FullArticleContentArray.count)", callback: { () -> Void in
            })
            tableView.reloadData()
            completionWidth = self.view.frame.width * (CGFloat(ParagraphCount+1) / CGFloat(FullArticleContentArray.count))
            completionBar.snp_updateConstraints(closure: { (make) -> Void in
                make.width.equalTo(completionWidth)
            })
        }
    }
    override func viewDidLoad() {
        completionWidth = self.view.frame.width * (CGFloat(ParagraphCount+1) / CGFloat(FullArticleContentArray.count))
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.navigationItem.titleView = createNavigationTitleViewArticleRecordParagraph("Pargraph \(ParagraphCount+1) / \(FullArticleContentArray.count)", callback: { () -> Void in
        })
        self.view.addSubview(completionBar)
        if(ParagraphCount == 0) {
            backwardButton.hidden = true
        } else if (ParagraphCount+1 == FullArticleContentArray.count) {
            forwardButton.hidden = true
        }
        completionBar.backgroundColor = recordProgressColor
        completionBar.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(4)
            make.width.greaterThanOrEqualTo(completionWidth)
            make.left.top.equalTo(self.view)
        }
        let bottomBar = createBottomParagraphRecordingBar(self.view)
        self.view.addSubview(tableView)
        tableView.backgroundColor = backgroundColorAll
        self.view.backgroundColor = backgroundColorAll
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Test")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        //        tableView.scrollEnabled = false
        tableView.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(self.view)
            make.top.equalTo(completionBar.snp_bottom)
            make.bottom.equalTo(bottomBar.snp_top)
        }
        //Bottom bar buttons
        let recordButton = UIButton(type: UIButtonType.System) as UIButton
        let checkButton = UIButton(type: UIButtonType.System) as UIButton
        let trashButton = UIButton(type: UIButtonType.System) as UIButton
        
        forwardButton.frame = CGRectMake(50, 50, 70, 50)
        recordButton.frame = CGRectMake(100,100,100,100)
        bottomBar.addSubview(backwardButton)
        bottomBar.addSubview(forwardButton)
        bottomBar.addSubview(recordButton)
        bottomBar.addSubview(checkButton)
        bottomBar.addSubview(trashButton)
        
        forwardButton.addTarget(self, action: "forwardParagraph", forControlEvents: .TouchUpInside)
        backwardButton.addTarget(self, action: "backwardParagraph", forControlEvents: .TouchUpInside)
        
        backwardButton.setBackgroundImage(UIImage(named: "back"), forState: .Normal)
        forwardButton.setBackgroundImage(UIImage(named: "forward"), forState: .Normal)
        recordButton.setBackgroundImage(UIImage(named: "record-start"), forState: .Normal)
        checkButton.setBackgroundImage(UIImage(named: "check"), forState: .Normal)
        trashButton.setBackgroundImage(UIImage(named: "trash"), forState: .Normal)
        
        backwardButton.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(20)
            make.width.equalTo(30)
            make.centerY.equalTo(bottomBar.snp_centerY)
            make.left.equalTo(bottomBar.snp_left).offset(5)
        }
        forwardButton.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(20)
            make.width.equalTo(30)
            make.centerY.equalTo(bottomBar.snp_centerY)
            make.right.equalTo(bottomBar.snp_right).offset(-5)
        }
        recordButton.snp_makeConstraints { (make) -> Void in
            make.height.width.equalTo(40)
            make.center.equalTo(bottomBar.center)
        }
        checkButton.snp_makeConstraints { (make) -> Void in
            make.height.width.equalTo(30)
            make.left.equalTo(recordButton.snp_right).offset(30)
            make.centerY.equalTo(bottomBar.snp_centerY)
        }
        trashButton.snp_makeConstraints { (make) -> Void in
            make.height.width.equalTo(20)
            make.right.equalTo(recordButton.snp_left).offset(-30)
            make.centerY.equalTo(bottomBar.snp_centerY)
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellHeight = heightForJustifiedView(FullArticleContentArray[ParagraphCount].text!, font: recordArticleParagraphFont, width: (tableView.frame.width - 60), lineSpace: 5)
        //cell height is dynamically generated then constraint values are added
        return cellHeight + 30
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return generateRecordingParagraphCell(tableView, indexPath: indexPath)
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
}