//
//  RecordIndividualParagraph.swift
//  OutloudMVP
//
//  Created by Frederik Lohner on 27/Oct/15.
//  Copyright © 2015 Outloud. All rights reserved.
//

import Foundation
import UIKit

class RecordIndividualParagraph: UIViewController, UITableViewDelegate {
    let tableView = UITableView()
    override func viewDidLoad() {
        let longpress = UILongPressGestureRecognizer(target: self, action: "longPressGestureRecognized:")
        tableView.addGestureRecognizer(longpress)
        longpress.minimumPressDuration = 0.5
        
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.navigationItem.titleView = createNavigationTitleViewArticleRecordParagraph("Pargraph \(ParagraphCount+1)/\(FullArticleContentArray.count + 1)", callback: { () -> Void in
        })
        
        let bottomBar = createBottomParagraphRecordingBar(self.view)
        self.view.addSubview(tableView)
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.delegate = self
//        tableView.dataSource = self
        tableView.separatorStyle = .None
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Test")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.snp_makeConstraints { (make) -> Void in
            make.left.right.top.equalTo(self.view)
            make.bottom.equalTo(bottomBar.snp_top)
        }
    }
}