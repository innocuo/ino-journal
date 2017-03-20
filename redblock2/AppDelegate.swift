//
//  AppDelegate.swift
//  redblock2
//
//  Created by Luis Orozco on 3/19/17.
//  Copyright © 2017 Luis Orozco. All rights reserved.
//

import Cocoa
import Carbon

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
    let popover = NSPopover()
    let menu = NSMenu()
    
    var eventMonitor: EventMonitor!
    private var hotKey: HotKey?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        if let button = statusItem.button {
            let img = NSImage(named: "StatusBarButtonImage")
            img?.isTemplate = true
            
            button.target = self
            button.image = img
            
            button.toolTip="InoJournal"
            //button.highlighted = true
            //button.highlight(true)
            
            //button.action = #selector(AppDelegate.togglePopover(_:))
            button.action = #selector(AppDelegate.handleAction(_:))
            button.sendAction(on: NSEventMask(rawValue: UInt64(Int((NSEventMask.leftMouseDown.rawValue | NSEventMask.leftMouseUp.rawValue | NSEventMask.rightMouseDown.rawValue | NSEventMask.rightMouseUp.rawValue)))))
            
        }
        let quietView:QuietViewController = QuietViewController(nibName: "QuietViewController", bundle: nil)!
        quietView.setDelegate(self)
        popover.contentViewController = quietView
        //popover.appearance = NSAppearance(named: NSAppearanceNameVibrantLight)
        popover.animates = false
        //popover.behavior = NSPopoverBehavior.Transient
        
        
        //let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Print Quote", action: #selector(AppDelegate.printQuote(_:)), keyEquivalent: "P"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit Quiet", action: #selector(AppDelegate.quitApp(_:)), keyEquivalent: "q"))
        
        eventMonitor = EventMonitor(mask: [.rightMouseUp , .leftMouseUp]) { [unowned self] event in
            if self.popover.isShown{
                self.closePopover(event)
            }
        }
        eventMonitor.start()
        
        hotKey = HotKey.register(keyCode: UInt32(kVK_ANSI_O), modifiers: UInt32(cmdKey|optionKey|controlKey), block: {
            self.togglePopover(self)
        })
    }
    
    func handleAction(_ sender:AnyObject){
        
        let event:NSEvent! = NSApp.currentEvent!
        if(event.type == .rightMouseDown){
            closePopover(sender)
            statusItem.popUpMenu(menu)
            //if let button = statusItem.button {
            //   statusItem.menu = menu
            //   statusItem.popUpStatusItemMenu(menu)
            //}
        }else if (event.type == .leftMouseUp){
            print("left mouse up")
            if popover.isShown{
                print("button should be highlighted")
                self.statusItem.button?.highlight(true)
            }
        }else if (event.type == .leftMouseDown){
            togglePopover(sender)
        }
        
    }
    
    
    
    func printQuote(_ sender:AnyObject){
        let quoteText = "This is today"
        let quoteAuthor = "Mark"
        
        print("\(quoteText) - \(quoteAuthor)")
    }
    
    func quitApp(_ sender:AnyObject?){
        NSApplication.shared().terminate(self)
    }
    
    func showPopover(_ sender:AnyObject?){
        if let button = statusItem.button{
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            statusItem.button?.highlight(true)
        }
        
        
    }
    
    func closePopover(_ sender:AnyObject?){
        popover.performClose(sender)
        self.statusItem.button?.highlight(false)
    }
    
    func togglePopover(_ sender:AnyObject?){
        print(popover.isShown)
        print("---")
        if popover.isShown{
            closePopover(sender)
        }else{
            showPopover(sender)
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        if let hk = hotKey {hk.unregister()}
    }
    
}


extension NSStatusBarButton {
    
    open override func mouseDown( with event: NSEvent) {
        
        //if (event.modifierFlags.contains(NSControlKeyMask)) {
        //   self.rightMouseDown(event)
        //return
        //}
        
        self.highlight(true)
        (self.target as? AppDelegate)?.togglePopover(self)
    }
}
