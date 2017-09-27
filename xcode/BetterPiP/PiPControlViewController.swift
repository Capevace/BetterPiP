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

class PiPControlViewController: NSViewController {

    @IBOutlet weak var playerView: AVPlayerView!
    
    var player: AVPlayer? = nil
    var pipIsActive = false
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
    
    func playVideo(videoUrl: URL, seconds: Float) {
        if (player !== nil && (player?.isPlaying)!) {
            player?.pause()
        }
        
        player = AVPlayer(url: videoUrl)
        
        let targetTime: CMTime = CMTimeMakeWithSeconds(Float64(seconds), Int32(NSEC_PER_SEC));
        player?.seek(to: targetTime)
        
        playerView.player = player;
        
        openPIP()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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

extension PiPControlViewController: PIPViewControllerDelegate {
    /// Called when the PIPPanel closes
    func pipDidClose(_ pip: PIPViewController!) {
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
