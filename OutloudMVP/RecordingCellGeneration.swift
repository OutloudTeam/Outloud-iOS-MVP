//
//  RecordingCellGeneration.swift
//  OutloudMVP
//
//  Created by Frederik Lohner on 27/Oct/15.
//  Copyright © 2015 Outloud. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
func generateRecordingArticleCell(tableView: UITableView, indexPath: NSIndexPath, cellToRecordAt: Int) -> UITableViewCell {
    let paragraphCell = UITableViewCell(style: .Default, reuseIdentifier: "articleCell")
    paragraphCell.backgroundColor = backgroundColorAll
    let paragraph = UILabel()
    paragraphCell.addSubview(paragraph)
    paragraph.text = FullArticleContentArray[indexPath.row].text
    transformIntoJustified(paragraph, lineSpace: 1)
    paragraph.textColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
    paragraph.font = recordArticleParagraphFont
    paragraph.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(paragraphCell.snp_left).offset(30)
        make.right.equalTo(paragraphCell.snp_right).offset(-30)
        make.top.equalTo(paragraphCell.snp_top).offset(10)
    }
    
    if(cellToRecordAt == indexPath.row){
        paragraph.textColor = UIColor.blackColor()
    }
    paragraphCell.selectionStyle = .None
    return paragraphCell
}



func generateRecordingParagraphCell(tableView: UITableView, indexPath: NSIndexPath) -> UITableViewCell {
    let paragraphCell = UITableViewCell(style: .Default, reuseIdentifier: "articleCell")
    paragraphCell.backgroundColor = backgroundColorAll
    let paragraph = UILabel()
    paragraphCell.addSubview(paragraph)
    paragraph.text = FullArticleContentArray[ParagraphCount].text
    transformIntoJustified(paragraph, lineSpace: 5)
    paragraph.font = recordArticleParagraphFont
    
    
    paragraph.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(paragraphCell.snp_left).offset(30)
        make.right.equalTo(paragraphCell.snp_right).offset(-30)
        make.top.equalTo(paragraphCell.snp_top).offset(30)
    }
    
    //    paragraphCell.selectionStyle = .None
    
    return paragraphCell
}

func generateRecordingHeaderCell(tableView : UITableView) -> UIView {
    let headerView = UIView()
    let authorName = UILabel()
    let articleTitle = UILabel()
    let articleLink = UILabel()
    
    headerView.addSubview(articleTitle)
    headerView.addSubview(authorName)
    headerView.addSubview(articleLink)
    
    headerView.backgroundColor = backgroundColorAll
    
    articleTitle.text = ArticleDetailArray[0].title
    transformIntoJustified(articleTitle, lineSpace: 3)
    articleTitle.font = recordArticleTitleFont
    articleTitle.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(headerView).offset(30)
        make.top.equalTo(headerView).offset(40)
        make.right.equalTo(headerView.snp_right).offset(-30)
    }
    //
    
    authorName.text = ArticleDetailArray[0].author
    transformIntoJustified(authorName, lineSpace: 3)
    authorName.font = authorNameFont
    authorName.textColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
    
    
    authorName.snp_makeConstraints { (make) -> Void in
        make.top.equalTo(articleTitle.snp_bottom).offset(10)
        make.left.equalTo(articleTitle.snp_left)
        make.right.equalTo(articleTitle.snp_right)
    }
    
    
    articleLink.textColor = transparentBlack
    articleLink.font = articleLinkFont
    
    articleLink.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(authorName.snp_left)
        make.top.equalTo(authorName.snp_bottom).offset(2)
    }
    let separatorBar = UIView()
    headerView.addSubview(separatorBar)
    separatorBar.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
    separatorBar.snp_makeConstraints { (make) -> Void in
        make.height.equalTo(1)
        make.top.equalTo(articleLink.snp_bottom).offset(15)
        make.left.equalTo(articleTitle.snp_left)
        make.right.equalTo(articleTitle.snp_right)
    }
    guard let fullURL = ArticleDetailArray[0].url else {
        articleLink.text = "Not Found"
        return headerView
    }
    let fullURLArray = fullURL.characters.split{$0 == "."}.map(String.init)
    articleLink.text = fullURLArray[1]
    
    return headerView
}

func generateListenHeaderCell(tableView : UITableView) -> UIView {
    let headerView = UIView()
    let authorName = UILabel()
    let articleTitle = UILabel()
    let articleLink = UILabel()
    
    headerView.addSubview(articleTitle)
    headerView.addSubview(authorName)
    headerView.addSubview(articleLink)
    
    headerView.backgroundColor = backgroundColorAll
    
    articleTitle.text = ArticleDetailArray[0].title
    transformIntoJustified(articleTitle, lineSpace: 3)
    articleTitle.font = articleListTileFont
    articleTitle.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(headerView).offset(30)
        make.top.equalTo(headerView).offset(30)
        make.right.equalTo(headerView.snp_right).offset(-30)
    }
    //
    
    authorName.text = ArticleDetailArray[0].author
    transformIntoJustified(authorName, lineSpace: 3)
    authorName.font = authorNameFont
    authorName.textColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
    
    
    authorName.snp_makeConstraints { (make) -> Void in
        make.top.equalTo(articleTitle.snp_bottom).offset(10)
        make.left.equalTo(articleTitle.snp_left)
        make.right.equalTo(articleTitle.snp_right)
    }
    
    
    articleLink.textColor = transparentBlack
    articleLink.font = articleLinkFont
    
    articleLink.snp_makeConstraints { (make) -> Void in
        make.left.equalTo(authorName.snp_left)
        make.top.equalTo(authorName.snp_bottom)
    }
    let separatorBar = UIView()
    headerView.addSubview(separatorBar)
    separatorBar.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.15)
    separatorBar.snp_makeConstraints { (make) -> Void in
        make.height.equalTo(1)
        make.top.equalTo(articleLink.snp_bottom).offset(15)
        make.left.right.equalTo(headerView)
    }
    guard let fullURL = ArticleDetailArray[0].url else {
        articleLink.text = "Not Found"
        return headerView
    }
    let fullURLArray = fullURL.characters.split{$0 == "."}.map(String.init)
    articleLink.text = fullURLArray[1]
    
    return headerView
}