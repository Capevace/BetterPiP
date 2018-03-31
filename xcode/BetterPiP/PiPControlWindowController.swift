//
//  LMVideoWindowController.swift
//  BetterPiP
//
//  Created by Lukas on 22.09.17.
//  Copyright © 2017 Lukas von Mateffy. All rights reserved.
//

import Cocoa
import Foundation

final class PiPControlWindowController: NSWindowController {

    var mainVC: PiPControlViewController! = nil
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
//        self.window?.makeKeyAndOrderFront(nil)
//        self.window?.close()
    }
    
    func showVideo(url: URL, seconds: Float) {
        if (mainVC !== nil) {
//            mainVC.dismiss(nil)
        } else {
        mainVC = NSStoryboard(name:NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "mainWindowVC")) as! PiPControlViewController
        self.window?.contentViewController = mainVC
        }
        mainVC.playVideo(videoUrl: url, seconds: seconds)
    }

}
