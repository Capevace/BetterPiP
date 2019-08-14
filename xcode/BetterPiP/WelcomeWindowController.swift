//
//  LMVideoWindowController.swift
//  BetterPiP
//
//  Created by Lukas on 14.08.19.
//  Copyright © 2019 Lukas von Mateffy. All rights reserved.
//

import Cocoa
import Foundation

final class WelcomeWindowController: NSWindowController {
    
    var mainVC: NSViewController! = nil
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        mainVC = NSStoryboard(name:NSStoryboard.Name(rawValue: "Welcome"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "welcomeWindowVC")) as! NSViewController
        self.window?.contentViewController = mainVC

        self.window?.makeKeyAndOrderFront(self)
        //        self.window?.close()
    }
}

