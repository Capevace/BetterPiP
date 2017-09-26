//
//  LMVideoWindowController.swift
//  BetterPiP
//
//  Created by Lukas on 22.09.17.
//  Copyright © 2017 Lukas von Mateffy. All rights reserved.
//

import Cocoa
import Foundation

class LMVideoWindowController: NSWindowController {

    var mainVC: ViewController! = nil
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.onMessage), name: NSNotification.Name(rawValue: "key"), object: nil)

        
        self.window?.makeKeyAndOrderFront(nil)
        self.window?.close()
    }
    
    func onMessage() {
        print("Got Message")
    }
    
    func showVideo(url: URL, seconds: Float64) {
        if (mainVC !== nil) {
            mainVC.dismiss(nil)
        }
        
        mainVC = NSStoryboard(name:"Main", bundle: nil).instantiateController(withIdentifier: "mainWindowVC") as! ViewController
        
        self.window?.contentViewController = mainVC
        
        mainVC.playVideo(videoUrl: url, seconds: seconds)
    }

}
