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

    var main: PiPControlWindowController!
    let statusItem = NSStatusBar.system().statusItem(withLength:NSSquareStatusItemLength)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        let appleEventManager = NSAppleEventManager.shared()
        appleEventManager.setEventHandler(self, andSelector: #selector(handleURL), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
        
        if let button = statusItem.button {
            button.image = NSImage(named: NSImage.Name(string: "StatusBarButtonImage") as String)
        }
        
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Install Chrome Extension", action: #selector(openChromeExtensionPage), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit BetterPiP", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }
    
    func handleURL(event: NSAppleEventDescriptor, reply: NSAppleEventDescriptor) {
        let window = NSStoryboard(name : "Main", bundle: nil).instantiateController(withIdentifier: "mainWindow") as! PiPControlWindowController
        
        let url = URL(string: (event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue)!)
        let queryUrl: String = ((url?.queryParameters?["url"]!)!).removingPercentEncoding!
        let startTimeString: String = (url?.queryParameters?["time"])!
        var startTime: Float = 0.0;
        
        if (startTimeString != "" || startTimeString != "undefined") {
            startTime = Float(startTimeString)!
        }
        
        print("Received URL: \(queryUrl)")
        print("Start at: \(startTime)")
        
        window.showVideo(url: URL(string: queryUrl)!, seconds: startTime)
    }

    func notify(message: String) {
        let notification = NSUserNotification()
        notification.title = "BetterPiP"
        notification.informativeText = message
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    func openChromeExtensionPage() {
        if let url = URL(string: "https://www.google.com"), NSWorkspace.shared().open(url) {
            print("default browser was successfully opened")
        }

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
