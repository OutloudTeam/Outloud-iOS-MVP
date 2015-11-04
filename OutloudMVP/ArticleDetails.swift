//
//  SnapkitTests.swift
//  OutloudMVP
//
//  Created by Frederik Lohner on 10/Oct/15.
//  Copyright © 2015 Outloud. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import AVFoundation


class ArticleDetail: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //BUTTONS
    let playButton = UIButton(type: UIButtonType.System) as UIButton
    let skipBackButton = UIButton(type: UIButtonType.System) as UIButton
    let skipForwardButton =  UIButton(type: UIButtonType.System) as UIButton
    let upvoteButton = UIButton(type: UIButtonType.System) as UIButton
    let downvoteButton = UIButton(type: UIButtonType.System) as UIButton
    let shareButton = UIButton(type: UIButtonType.System) as UIButton
    
    let voteCount = UILabel()
    var intVoteCount = 1023
    var tableView = UITableView(frame: CGRectMake(100, 100, 100, 100))
    var scrollView: UIScrollView!
    
    override func viewDidAppear(animated: Bool) {
        self.navigationItem.titleView = createNavigationTitleViewArticleDetail("Outloud!", callback: { () -> Void in

        })
        self.navigationItem.titleView?.snp_makeConstraints(closure: { (make) -> Void in
            make.width.equalTo(tableView.frame.width)
            make.top.equalTo((self.navigationController?.view)!).offset(20)
            
        })
    }
    
    override func viewDidLoad() {
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorStyle = .None
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Test")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.edgesForExtendedLayout = UIRectEdge.None
        
        let bottomBar = createBottomArticleDetailBar(self.view)
        //Bottom bar
        playButton.frame = CGRectMake(50, 50, 50, 50)
        playButton.setBackgroundImage(UIImage(named: "play-button"), forState: .Normal)
        bottomBar.addSubview(playButton)
        playButton.addTarget(self, action: "playSound", forControlEvents: .TouchUpInside)
        playButton.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(bottomBar)
            make.width.height.equalTo(40)
            make.centerX.equalTo(bottomBar.snp_centerX)
        }
        bottomBar.addSubview(skipBackButton)
        skipBackButton.frame = CGRectMake(50, 50, 50, 50)
        skipBackButton.setBackgroundImage(UIImage(named: "skip-back"), forState: .Normal)
        bottomBar.addSubview(playButton)
        skipBackButton.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(bottomBar.snp_centerY)
            make.height.equalTo(20)
            make.width.equalTo(25)
            make.right.equalTo(playButton.snp_left).offset(-8)
        }
        bottomBar.addSubview(skipForwardButton)
        skipForwardButton.frame = CGRectMake(50, 50, 50, 50)
        skipForwardButton.setBackgroundImage(UIImage(named: "skip-forward"), forState: .Normal)
        bottomBar.addSubview(skipForwardButton)
        skipForwardButton.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(bottomBar.snp_centerY)
            make.height.equalTo(20)
            make.width.equalTo(25)
            make.left.equalTo(playButton.snp_right).offset(8)
        }
        bottomBar.addSubview(upvoteButton)
        bottomBar.addSubview(downvoteButton)
        bottomBar.addSubview(shareButton)
        upvoteButton.frame = CGRectMake(50, 50, 50, 50)
        downvoteButton.frame = CGRectMake(50, 50, 50, 50)
        shareButton.frame = CGRectMake(50, 50, 50, 50)
        
        upvoteButton.setBackgroundImage(UIImage(named: "upvote"), forState: .Normal)
        downvoteButton.setBackgroundImage(UIImage(named: "downvote"), forState: .Normal)
        shareButton.setBackgroundImage(UIImage(named: "share"), forState: .Normal)
        
        upvoteButton.addTarget(self, action: "upVoteCast", forControlEvents: .TouchUpInside)
        downvoteButton.addTarget(self, action: "downVoteCast", forControlEvents: .TouchUpInside)
        
        voteCount.text = String(intVoteCount)
        
        voteCount.textColor = UIColor.whiteColor()
        bottomBar.addSubview(voteCount)
        
        bottomBar.addSubview(upvoteButton)
        bottomBar.addSubview(downvoteButton)
        bottomBar.addSubview(shareButton)
        voteCount.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(bottomBar.snp_left).offset(2)
            make.centerY.equalTo(bottomBar.snp_centerY)
        }
        
        upvoteButton.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(12)
            make.width.equalTo(18)
            make.centerX.equalTo(voteCount.snp_centerX)
            make.top.equalTo(bottomBar.snp_top).offset(10)
        }
        
        downvoteButton.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(12)
            make.width.equalTo(18)
            make.centerX.equalTo(voteCount.snp_centerX)
            make.bottom.equalTo(bottomBar.snp_bottom).offset(-10)
        }
        shareButton.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(20)
            make.top.equalTo(upvoteButton.snp_bottom)
            make.left.equalTo(upvoteButton.snp_right).offset(30)
        }
        
        let volumeSlider = UISlider(frame:CGRectMake(20, 260, 380, 20))
        volumeSlider.minimumValue = 0
        volumeSlider.maximumValue = 10
        volumeSlider.continuous = true
        volumeSlider.tintColor = UIColor.redColor()
        volumeSlider.value = 8
        bottomBar.addSubview(volumeSlider)
        volumeSlider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
        volumeSlider.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(bottomBar.snp_centerY)
            make.width.height.equalTo(80)
            make.left.equalTo(skipForwardButton.snp_right).offset(30)
        }
        
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
        return FullArticleContentArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let paragraph = UILabel()
        cell.addSubview(paragraph)
        paragraph.text = FullArticleContentArray[indexPath.row].text
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
//        cell.userInteractionEnabled = false
        
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let paragraph = UILabel()
        paragraph.text = ArticleDetailArray[0].fullContent[indexPath.row].text
        let fontTest = UIFont(name: "Helvetica", size: 14.0)
        paragraph.font = fontTest
        var cellHeight = heightForView(paragraph.text!, font: fontTest!, width: (tableView.frame.width - 60))
        cellHeight = cellHeight + 10
        return cellHeight
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return generateListenHeaderCell(tableView)
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let titleHeight = heightForJustifiedView(ArticleDetailArray[0].title!, font: recordArticleTitleFont, width: (tableView.frame.width - 60), lineSpace: 3)
        let authorHeight = heightForJustifiedView(ArticleDetailArray[0].author!, font: authorNameFont, width: (tableView.frame.width-60), lineSpace: 3)
        let articleHeight = heightForView("Placeholder.com", font: articleLinkFont, width: (tableView.frame.width - 60))
        
        //cell height is dynamically genrated then the constraint values are added to it
        return titleHeight + authorHeight + articleHeight + 57
    }
}
func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer?  {
    let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
    let url = NSURL.fileURLWithPath(path!)
    
    var audioPlayer:AVAudioPlayer?
    do {
        try audioPlayer = AVAudioPlayer(contentsOfURL: url)
    } catch {
        print("Player not available")
    }
    return audioPlayer
}