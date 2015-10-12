//
//  ViewController.swift
//  OutloudMVP
//
//  Created by Peyman Mortazavi on 10/10/15.
//  Copyright © 2015 Outloud. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var backgroundMusic : AVAudioPlayer?
    
    
    func setupGame()  {
        backgroundMusic?.volume = 1.0
        backgroundMusic?.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let backgroundMusic = setupAudioPlayerWithFile("TestAudio", type:"mp3") {
            self.backgroundMusic = backgroundMusic
        }
        setupGame()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer?  {
//        //1
//        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
//        let url = NSURL.fileURLWithPath(path!)
//        
//        //2
//        var audioPlayer:AVAudioPlayer?
//        
//        // 3
//        do {
//            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
//        } catch {
//            print("Player not available")
//        }
//        
//        return audioPlayer
//    }
    
    
}