
//  MainNavigationController.swift
//  OutloudMVP
//
//  Created by Peyman Mortazavi on 10/14/15.
//  Copyright © 2015 Outloud. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainViewController = ArticleListListen()
        self.edgesForExtendedLayout = UIRectEdge.None
        self.setViewControllers([mainViewController], animated: false)
        self.navigationBar.barTintColor = barColor
        self.navigationBar.tintColor = barTextColor
        self.navigationBar.translucent = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
