//
//  ReadingsIndividualArticle.swift
//  OutloudMVP
//
//  Created by Frederik Lohner on 13/Nov/15.
//  Copyright © 2015 Outloud. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import AVFoundation
import SwiftOverlays
import Alamofire

class ReadingsIndividualArticle: UIViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate {
    
    let listenContainer = UIButton()
    let middleView = UIView()
    var index: Int?
    //    func handleSingleTap(sender: UIButton) {
    //        let alert: UIAlertView = UIAlertView()
    //
    //        alert.addButtonWithTitle("Listen")
    //        alert.addButtonWithTitle("Record")
    //        alert.delegate = self  // set the delegate here
    //        alert.show()
    //    }
    //    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
    //        alertView.buttonTitleAtIndex(buttonIndex)
    //        print("\(buttonIndex) pressed")
    //        if buttonIndex == 0 {
    //            print("Listen was clicked")
    //            SwiftOverlays.showBlockingWaitOverlayWithText("Loading!")
    //            dispatch_async(dispatch_get_main_queue(), { () -> Void in
    //                SwiftOverlays.removeAllBlockingOverlays()
    //                self.navigationController?.setViewControllers([ArticleListListen()], animated: true)
    //            })
    //        } else {
    //            print("Record was clicked")
    //            SwiftOverlays.showBlockingWaitOverlayWithText("Loading!")
    //            dispatch_async(dispatch_get_main_queue(), { () -> Void in
    //                SwiftOverlays.removeAllBlockingOverlays()
    //                self.navigationController?.setViewControllers([ArticleListRecord()], animated: true)
    //            })
    //        }
    //    }
    var tableView = UITableView(frame: CGRectMake(100, 100, 100, 100), style: .Grouped)
    let playAllButton = UIButton(type: UIButtonType.System) as UIButton
    
    
    override func viewDidLoad() {
        self.title = ""
        self.edgesForExtendedLayout = UIRectEdge.None
        let bottomBar = createBottomArticleListBar(self.view)
        middleView.backgroundColor = UIColor.blueColor()
        self.view.addSubview(middleView)
        middleView.snp_makeConstraints { (make) -> Void in
            make.left.top.right.equalTo(self.view)
            make.bottom.equalTo(bottomBar.snp_top)
        }
        
        let destination = Alamofire.Request.suggestedDownloadDestination(directory: .DocumentDirectory, domain: .UserDomainMask)
        Alamofire.download(.GET, ReadingsListArray[0].url!, destination: destination)
            .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
                dispatch_async(dispatch_get_main_queue()) {
                    let progress = (Double(totalBytesRead) / Double(totalBytesExpectedToRead)) * 100
                    SwiftOverlays.showBlockingWaitOverlayWithText("Downloading Article: \(Int(progress))%!")
                    print("Total bytes read on main queue: \(progress)")
                }
            }
            .response { _, _, _, error in
                if let error = error {
                    print("Failed with error: \(error)")
                    SwiftOverlays.removeAllBlockingOverlays()
                } else {
                    print("Downloaded file successfully")
                    SwiftOverlays.removeAllBlockingOverlays()
                }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return generateReadingListCell(tableView, indexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
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
        
    }
}