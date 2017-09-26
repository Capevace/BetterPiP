//
//  ViewController.swift
//  BetterPiP
//
//  Created by Lukas on 22.09.17.
//  Copyright © 2017 Lukas von Mateffy. All rights reserved.
//

import Cocoa
import AVKit
import AVFoundation

class ViewController: NSViewController {

    @IBOutlet weak var playerView: AVPlayerView!
    
    @IBOutlet weak var txt: NSTextField!
    /// Create a new PIPViewController instance, set the delegate to self and set the aspect ratio of the video to 16:9
    lazy var pip: PIPViewController! = {
        let pip = PIPViewController()!
        pip.delegate = self
        pip.aspectRatio = CGSize(width: 16, height: 9)
        pip.userCanResize = false
        
        // These replacement properties are used to animate between the window and PIP
        pip.replacementWindow = self.view.window
        pip.replacementRect = self.view.bounds
        
        return pip
    }()
    
    /// Our AVPlayer instance
    var player: AVPlayer? = nil
    
    /// Whether the pipIsActive or not
    var pipIsActive = false
    
    var window: NSWindow?
    
    func playVideo(videoUrl: URL, seconds: Float64) {
        if (player !== nil && (player?.isPlaying)!) {
            player?.pause()
        }
        
        player = AVPlayer(url: videoUrl)
        
        let targetTime: CMTime = CMTimeMakeWithSeconds(seconds, Int32(NSEC_PER_SEC));
        player?.seek(to: targetTime)
        
        playerView.player = player;
        
        openPIP()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        //openPIP()
    }
    
    /// Displays the current view controller in picture in picture and sets the play button to be true.
    /// We added a pipIsActive flag here because it seems to get called twice. If the view controller has already presented then we'll get a crash from PIPViewController.
    /// We also keep an instance of the current view so when the PIPPanel closes we can return it back to its original state.
    func openPIP() {
        if !pipIsActive {
            pip.presentAsPicture(inPicture: self)
            pip.setPlaying(true)
            pipIsActive = true
        }
    }


}

extension ViewController: PIPViewControllerDelegate {
    
    /// Called when the PIPPanel closes
    func pipDidClose(_ pip: PIPViewController!) {
//        NSApplication.shared().terminate(self)
        player?.pause()
    }
    
    /// Called when the PIPPanel stops playing
    func pipActionStop(_ pip: PIPViewController!) {
        player?.pause()
    }
    
    /// Called when the play button in the PIPPanel is clicked
    func pipActionPlay(_ pip: PIPViewController!) {
        player?.play()
    }
    
    /// Called when the pause button in the PIPPanel is clicked
    func pipActionPause(_ pip: PIPViewController!) {
        player?.pause()
    }
    
}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
