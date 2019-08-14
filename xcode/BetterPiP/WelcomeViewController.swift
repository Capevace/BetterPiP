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
    
    @IBAction func onDoneClicked(sender: NSButton) {
        self.view.window?.windowController?.close()
    }
}

