//
//  ListenRecordSegmentClass.swift
//  OutloudMVP
//
//  Created by Frederik Lohner on 25/Nov/15.
//  Copyright © 2015 Outloud. All rights reserved.
//

import Foundation
import UIKit
class ListenRecordSegmentedController: UIControl {
    private var labels = [UILabel]()
    var thumbView = UIView()
    
    var items: [String] = ["Listen","Record"] {
        didSet {
            setupLabels()
        }
    }
    
    var selectedIndex: Int = 0 {
        didSet {
            displayNewSelectedIndex()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        setupView()
    }
    
    func setupView() {
        layer.cornerRadius = frame.height / 3.4
        layer.borderColor = UIColor.blackColor().CGColor
        layer.borderWidth = 2
        backgroundColor = UIColor.whiteColor()
        
        setupLabels()
        
        insertSubview(thumbView, atIndex: 0)
        
    }
    
    
    func setupLabels() {
        for label in labels {
            label.removeFromSuperview()
            
        }
        labels.removeAll(keepCapacity: true)
        for index in 1...items.count {
            let label = UILabel(frame: CGRectZero)
            label.text = items[index - 1]
            label.textAlignment = .Center
            label.textColor = UIColor.blackColor()
            self.addSubview(label)
            labels.append(label)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var selectedFrame = self.bounds
        let newWidth = CGRectGetWidth(selectedFrame) / CGFloat(items.count)
        selectedFrame.size.width = newWidth
        thumbView.frame = selectedFrame
        thumbView.backgroundColor = yellowColor
//        thumbView.layer.cornerRadius = thumbView.frame.height / 3.4
        
        let labelHeight = self.bounds.height
        let labelWidth = self.bounds.width / CGFloat(labels.count)
        
        for index in 0...labels.count - 1 {
            let label = labels[index]
            
            let xPosition = CGFloat(index) * labelWidth
            label.frame = CGRectMake(xPosition, 0, labelWidth, labelHeight)
        }
    }
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        let location = touch.locationInView(self)
        var calculatedIndex: Int?
        for(index, item) in EnumerateSequence(labels) {
            if item.frame.contains(location) {
                calculatedIndex = index
            }
        }
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActionsForControlEvents(.ValueChanged)
            if selectedIndex == 0 {
                thumbView.backgroundColor = yellowColor
            } else {
                thumbView.backgroundColor = redColor
            }
        }
        return false
    }
    
    func displayNewSelectedIndex() {
        let label = labels[selectedIndex]
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [], animations: {
            
            self.thumbView.frame = label.frame
            
            }, completion: nil)

    }
}