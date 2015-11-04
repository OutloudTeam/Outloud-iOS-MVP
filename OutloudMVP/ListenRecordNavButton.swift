//
//  ListenRecordNavButton.swift
//  OutloudMVP
//
//  Created by Frederik Lohner on 1/Nov/15.
//  Copyright © 2015 Outloud. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SwiftOverlays

class ListenRecordButton : UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    init() {
        super.init(frame: CGRectZero)
        self.addTarget(self, action: "handleSingleTap:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    func handleSingleTap(sender: UIButton) {
        let alert: UIAlertView = UIAlertView()
        
        let yesBut = alert.addButtonWithTitle("Listen")
        let noBut = alert.addButtonWithTitle("Record")
        alert.delegate = self  // set the delegate here
        alert.show()
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let buttonTitle = alertView.buttonTitleAtIndex(buttonIndex)
        print("\(buttonIndex) pressed")
        if buttonIndex == 0 {
            print("Listen was clicked")
//            SwiftOverlays.showBlockingWaitOverlayWithText("Loading!")
//            articleListJSONGet({ () -> () in
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    createNavigationTitleViewArticleList("KIK", category: "KEK", callback: { () -> Void in
//                        SwiftOverlays.removeAllBlockingOverlays()
//                        print("OK")
//                    })
//                    
//                })
//                
//            })
        } else {
            print("Record was clicked")
        }
    }
    
}