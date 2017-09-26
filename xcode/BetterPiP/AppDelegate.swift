//
//  AppDelegate.swift
//  BetterPiP
//
//  Created by Lukas on 22.09.17.
//  Copyright © 2017 Lukas von Mateffy. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var main: LMVideoWindowController!
    
    override func application(_ sender: NSApplication, delegateHandlesKey key: String) -> Bool {
        return key == "videos"
    }
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        let appleEventManager = NSAppleEventManager.shared()
        appleEventManager.setEventHandler(self, andSelector: #selector(handleURL), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
        
//        main = NSStoryboard(name : "Main", bundle: nil).instantiateController(withIdentifier: "mainWindow") as! LMVideoWindowController
    }
    
    func handleURL(event: NSAppleEventDescriptor, reply: NSAppleEventDescriptor) {
        let window = NSStoryboard(name : "Main", bundle: nil).instantiateController(withIdentifier: "mainWindow") as! LMVideoWindowController
        
        let url = URL(string: (event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue)!)
        print("REAL URL: \(url)")
        
        let queryUrl: String = ((url?.queryParameters?["url"]!)!).removingPercentEncoding!
        print("URL: \(queryUrl)")
        
        window.showVideo(url: URL(string: queryUrl)!, seconds: 0.0)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func notify(message: String) {
        let notification = NSUserNotification()
        notification.title = "BetterPiP"
        notification.informativeText = message
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.deliver(notification)
    }
}

extension URL {
    
    public var queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
            return nil
        }
        
        var parameters = [String: String]()
        for item in queryItems {
            parameters[item.name] = item.value
        }
        
        return parameters
    }
}
