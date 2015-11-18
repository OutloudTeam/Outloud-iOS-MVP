//
//  RecordButton.swift
//  OutloudMVP
//
//  Created by Peyman Mortazavi on 10/11/15.
//  Copyright © 2015 Outloud. All rights reserved.
//

import UIKit
import SnapKit

class RecordButton: UIButton {
    
    var innerView: UIView = UIView();
    var isRecording: Bool = false;
 
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    init() {
        super.init(frame: CGRectZero)
        
        innerView.userInteractionEnabled = false
        self.addTarget(self, action: "handleSingleTap:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.layer.borderColor = redColor.CGColor
        self.backgroundColor = redColor
        self.layer.borderWidth = 4
        self.layer.masksToBounds = true
        innerView.backgroundColor = UIColor.whiteColor()
        addSubview(innerView)
    }
    
    override func layoutSubviews() {
        innerView.layer.cornerRadius = self.bounds.width/20;
        if(isRecording) {
            innerView.frame = self.bounds.insetBy(dx: self.bounds.width/4, dy: self.bounds.width/4);
        }else{
            innerView.frame = self.bounds.insetBy(dx: -1, dy: -1);
        }
        self.layer.cornerRadius = self.bounds.width/2;
    }
    
    func setRecording(recording: Bool, animate: Bool) {
        isRecording = recording;
        
        if(animate){
            UIView.animateWithDuration(0.25, animations: {
                self.layoutSubviews();
            });
        }else{
            self.layoutSubviews();
        }
    }
    
    func handleSingleTap(sender: UIButton) {
        setRecording(!isRecording, animate: true);
    }

}
