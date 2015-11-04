//
//  ListenCellGeneration.swift
//  OutloudMVP
//
//  Created by Frederik Lohner on 3/Nov/15.
//  Copyright © 2015 Outloud. All rights reserved.
//

import Foundation
import UIKit

func generateListenArticleCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
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
    transformIntoJustified(paragraph, lineSpace: 3)
    paragraph.font = listenArticleFont
    paragraph.textColor = UIColor.blackColor()
    cell.userInteractionEnabled = false
    
    return cell
}