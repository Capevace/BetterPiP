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
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let menu = NSMenu()
    var launchedWithUrl = false
    
    var welcomeWindow: WelcomeWindowController!
    var playVideoWindow: NSWindowController!
    
    func application(_ application: NSApplication, open urls: [URL]) {
        print("launched with url")
        
        launchedWithUrl = true
        
        if urls.count == 0 { return }
        
        let url = urls[0]
        guard let queryUrl: String = ((url.queryParameters?["url"]!)!).removingPercentEncoding else { return }
        guard let startTimeString: String = (url.queryParameters?["time"]) else { return }
        
        var startTime: Float = 0.0;
        
        if (startTimeString != "" || startTimeString != "undefined") {
            startTime = Float(startTimeString)!
        }
        
        // Open PiP Window
        guard let window = NSStoryboard(name : NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "mainWindow")) as? PiPControlWindowController else { return }
        
        //print("Received URL: \(queryUrl)")
        //print("Start at: \(startTime)")
        
        window.showVideo(url: URL(string: queryUrl)!, seconds: startTime)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Set the app as an accessory and then push it to the front to show the welcome panel
        NSApp.setActivationPolicy(.accessory)
        NSApp.activate(ignoringOtherApps: true)
        
        // Subscribe to URL events (for opening links once the app is open already)
        let appleEventManager = NSAppleEventManager.shared()
        appleEventManager.setEventHandler(self, andSelector: #selector(handleURL), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
        
        // Add Status Bar Icon and Menu
        if let button = statusItem.button {
            button.image = NSImage(named: NSImage.Name("StatusBarButtonImage"))
        }
        
        menu.addItem(NSMenuItem(title: "About BetterPiP", action: #selector(showAboutWindow), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Play Video Stream", action: #selector(openPlayVideoWindow), keyEquivalent: "p"))
        menu.addItem(NSMenuItem(title: "Install Extensions", action: #selector(openExtensionPage), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Help", action: #selector(openHelpPage), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit BetterPiP", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
        
        // Show the welcome panel
        welcomeWindow = NSStoryboard(name : NSStoryboard.Name(rawValue: "Welcome"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "welcomeWindow")) as! WelcomeWindowController
        welcomeWindow.showWindow(self)
        
    }
    
    // Handle an incoming URL (betterpip: scheme)
    @objc func handleURL(event: NSAppleEventDescriptor, reply: NSAppleEventDescriptor) {
        let window = NSStoryboard(name : NSStoryboard.Name(rawValue: "Main"), bundle: nil).instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "mainWindow")) as! PiPControlWindowController

        let url = URL(string: (event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue)!)
        let queryUrl: String = ((url?.queryParameters?["url"]!)!).removingPercentEncoding!
        let startTimeString: String = (url?.queryParameters?["time"])!
        var startTime: Float = 0.0;

        if (startTimeString != "" || startTimeString != "undefined") {
            startTime = Float(startTimeString)!
        }

        //print("Received URL: \(queryUrl)")
        //print("Start at: \(startTime)")

        window.showVideo(url: URL(string: queryUrl)!, seconds: startTime)
    }

    
//    func notify(message: String) {
//        let notification = NSUserNotification()
//        notification.title = "BetterPiP"
//        notification.informativeText = message
//        notification.soundName = NSUserNotificationDefaultSoundName
//        NSUserNotificationCenter.default.deliver(notification)
//    }
    
    // Force the application in front and show the about panel
    @objc func showAboutWindow() {
        NSApp.activate(ignoringOtherApps: true)
        NSApplication.shared.orderFrontStandardAboutPanel(self)
    }
    
    // Open the help page website
    @objc func openHelpPage() {
        if let url = URL(string: "https://mateffy.me/betterpip/help"), NSWorkspace.shared.open(url) {
            print("help page opened")
        }
    }
    
    // Open the webpage to install the extensions
    @objc func openExtensionPage() {
        if let url = URL(string: "https://mateffy.me/betterpip/extensions"), NSWorkspace.shared.open(url) {
            print("extensions page opened")
        }
    }
    
    // Open play video window
    @objc func openPlayVideoWindow() {
        NSApp.activate(ignoringOtherApps: true)
        
        if (playVideoWindow !== nil) {
            playVideoWindow.close()
        }
        
        playVideoWindow = NSStoryboard(name:NSStoryboard.Name(rawValue: "Main"), bundle: nil)
            .instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "playVideoWindow")) as! NSWindowController
        playVideoWindow.showWindow(self)
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
