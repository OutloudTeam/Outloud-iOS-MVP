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
    let playButton = UIButton()
    let skipBackButton = UIButton(type: UIButtonType.System) as UIButton
    let skipForwardButton =  UIButton(type: UIButtonType.System) as UIButton
    let upvoteButton = UIButton(type: UIButtonType.System) as UIButton
    let downvoteButton = UIButton(type: UIButtonType.System) as UIButton
    let shareButton = UIButton(type: UIButtonType.System) as UIButton
    let progressBar = UIView()
    
    let voteCount = UILabel()
    var intVoteCount = 1023
    var tableView = UITableView(frame: CGRectMake(100, 100, 100, 100))
    var scrollView: UIScrollView!
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        self.navigationItem.titleView = createNavigationTitleViewArticleDetail(true, title: "Outloud!", callback: { () -> Void in
        })
        
        progressBar.backgroundColor = yellowColor
        self.view.addSubview(progressBar)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorStyle = .None
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Test")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.view.backgroundColor = UIColor.whiteColor()
        let bottomBar = createBottomArticleDetailBar(self.view)
        progressBar.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.view)
            make.bottom.equalTo(bottomBar.snp_top)
            make.height.equalTo(5)
            make.width.equalTo(50)
        }
        //Bottom bar
        playButton.frame = CGRectMake(50, 50, 50, 50)
        playButton.setBackgroundImage(UIImage(named: "play-button"), forState: .Normal)
        
        playButton.setBackgroundImage(UIImage(named: "pause-button"), forState: .Selected)
        playButton.addTarget(self, action: "play_tapped", forControlEvents: UIControlEvents.TouchUpInside)
        
        bottomBar.addSubview(playButton)
        playButton.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(bottomBar)
            make.width.height.equalTo(35)
            make.centerX.equalTo(bottomBar.snp_centerX)
        }
        bottomBar.addSubview(skipBackButton)
        skipBackButton.frame = CGRectMake(50, 50, 50, 50)
        skipBackButton.setBackgroundImage(UIImage(named: "skip-back"), forState: .Normal)
        bottomBar.addSubview(playButton)
        skipBackButton.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(bottomBar.snp_centerY)
            make.height.equalTo(25)
            make.width.equalTo(30)
            make.right.equalTo(playButton.snp_left).offset(-50)
        }
        bottomBar.addSubview(skipForwardButton)
        skipForwardButton.frame = CGRectMake(50, 50, 50, 50)
        skipForwardButton.setBackgroundImage(UIImage(named: "skip-forward"), forState: .Normal)
        bottomBar.addSubview(skipForwardButton)
        skipForwardButton.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(bottomBar.snp_centerY)
            make.height.equalTo(25)
            make.width.equalTo(30)
            make.left.equalTo(playButton.snp_right).offset(50)
        }
        
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Test")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.snp_makeConstraints { (make) -> Void in
            make.left.right.top.equalTo(self.view)
            make.bottom.equalTo(progressBar.snp_top)
        }
    }
    
    func play_tapped(){
        playButton.selected = !playButton.selected
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FullArticleContentArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return generateListenArticleCell(tableView, indexPath: indexPath)
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cellHeight = heightForJustifiedView(FullArticleContentArray[indexPath.row].text!, font: listenArticleFont, width: (tableView.frame.width - 60), lineSpace: 3)
        //cell height is dynamically generated then constraint values are added
        return cellHeight + 10
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return generateListenHeaderCell(tableView)
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let titleHeight = heightForJustifiedView(ArticleDetailArray[0].title!, font: articleListTileFont, width: (tableView.frame.width - 60), lineSpace: 3)
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