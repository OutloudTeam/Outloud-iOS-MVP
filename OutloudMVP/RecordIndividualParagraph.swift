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
    var tableView = UITableView(frame: CGRectMake(100, 100, 100, 100), style: .Grouped)
    let completionBar = UIView()
    
    func forwardParagraph() {
        if(ParagraphCount < FullArticleContentArray.count-1) {
            ParagraphCount++
            self.navigationItem.titleView = createNavigationTitleViewArticleRecordParagraph("Pargraph \(ParagraphCount+1)/\(FullArticleContentArray.count)", callback: { () -> Void in
            })
            tableView.reloadData()
        }
    }
    func backwardParagraph() {
        if(ParagraphCount > 0) {
            ParagraphCount--
            self.navigationItem.titleView = createNavigationTitleViewArticleRecordParagraph("Pargraph \(ParagraphCount+1)/\(FullArticleContentArray.count)", callback: { () -> Void in
            })
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.navigationItem.titleView = createNavigationTitleViewArticleRecordParagraph("Pargraph \(ParagraphCount+1)/\(FullArticleContentArray.count)", callback: { () -> Void in
        })
        self.view.addSubview(completionBar)
        completionBar.backgroundColor = recordProgressColor
        completionBar.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(4)
            make.width.equalTo(30)
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
        tableView.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(self.view)
            make.top.equalTo(completionBar.snp_bottom)
            make.bottom.equalTo(bottomBar.snp_top)
        }
        //Bottom bar buttons
        let backwardButton = UIButton(type: UIButtonType.System) as UIButton
        let forwardButton = UIButton(type: UIButtonType.System) as UIButton
        let recordButton = UIButton(type: UIButtonType.System) as UIButton
        let checkButton = UIButton(type: UIButtonType.System) as UIButton
        let trashButton = UIButton(type: UIButtonType.System) as UIButton
        
        forwardButton.frame = CGRectMake(50, 50, 50, 50)
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
            make.width.equalTo(20)
            make.centerY.equalTo(bottomBar.snp_centerY)
            make.left.equalTo(bottomBar.snp_left).offset(5)
        }
        forwardButton.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(20)
            make.width.equalTo(20)
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
        let cellHeight = heightForView(FullArticleContentArray[ParagraphCount].text!, font: recordArticleParagraphFont!, width: (tableView.frame.width - 60))
        return cellHeight + 120
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return generateRecordingParagraphCell(tableView, indexPath: indexPath)
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return generateRecordingHeaderCell(tableView)
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        let cellHeight = heightForView(ArticleDetailArray[0].title!, font: largeTitleFont!, width: (tableView.frame.width - 60))
//        return cellHeight + 60
        return 140
    }
}