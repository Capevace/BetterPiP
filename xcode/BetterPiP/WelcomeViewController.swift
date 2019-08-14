//
//  WelcomeViewController.swift
//  BetterPiP
//
//  Created by Lukas on 14.08.19.
//  Copyright © 2019 Lukas von Mateffy. All rights reserved.
//

import Cocoa
import AVKit
import AVFoundation

final class WelcomeViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onChromeClicked(sender: NSButton) {
        if let url = URL(string: "https://mateffy.me/betterpip/extensions#chrome"), NSWorkspace.shared.open(url) {
            print("chrome page opened")
        }
        
        self.view.window?.windowController?.close()
    }
    
    @IBAction func onFirefoxClicked(sender: NSButton) {
        if let url = URL(string: "https://mateffy.me/betterpip/extensions#firefox"), NSWorkspace.shared.open(url) {
            print("firefox page opened")
        }
        
        self.view.window?.windowController?.close()
    }
    
    @IBAction func onDoneClicked(sender: NSButton) {
        self.view.window?.windowController?.close()
    }
}

