//
//  PlayVideoViewController.swift
//  BetterPiP
//
//  Created by Lukas on 14.08.19.
//  Copyright © 2019 Lukas von Mateffy. All rights reserved.
//

import Cocoa
import AVKit
import AVFoundation

final class PlayVideoViewController: NSViewController {
    
    @IBOutlet var urlField : NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onPlayPressed(sender: NSButton) {
        let window = NSStoryboard(name : NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "mainWindow")) as! PiPControlWindowController
        
        window.showVideo(url: URL(string: urlField.stringValue)!, seconds: 0.0)
        
        self.view.window?.windowController?.close()
    }
}


