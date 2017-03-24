//
//  AppDelegate.swift
//  InoJournal
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
    
    private var button:NSStatusBarButton?
    
    var eventMonitor: EventMonitor!
    private var hotKey: HotKey?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        //create menu bar icon button
        self.button = statusItem.button!
        if ((self.button) != nil) {
            let img = NSImage(named: "StatusBarButtonImage")
            img?.isTemplate = true
            
            self.button?.target = self
            self.button?.image = img
            
            self.button?.toolTip="InoJournal"
            
            //track left and right clicks, each shows a different thing
            self.button?.action = #selector(AppDelegate.handleAction(_:))
            self.button?.sendAction(on: NSEventMask(rawValue: UInt64(Int((NSEventMask.rightMouseDown.rawValue | NSEventMask.rightMouseUp.rawValue)))))
            
        }
        let quietView:QuietViewController = QuietViewController(nibName: "QuietViewController", bundle: nil)!
        quietView.setDelegate(self)
        
        
        popover.contentViewController = quietView
        popover.animates = false
        
        //popover.appearance = NSAppearance(named: NSAppearanceNameVibrantLight)
        //popover.behavior = NSPopoverBehavior.Transient
        
        //add menu items
        menu.addItem(NSMenuItem(title: "Print Quote", action: #selector(AppDelegate.printQuote(_:)), keyEquivalent: "P"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(AppDelegate.quitApp(_:)), keyEquivalent: "q"))
        
        //this is needed for when user clicks on another statusItem
        eventMonitor = EventMonitor(mask: [.rightMouseUp , .leftMouseUp]) { [unowned self] event in
            print("event monitor event happened")
            if self.popover.isShown{
               self.closePopover(event)
            }
        }
        eventMonitor.start()
        
        //hot key is ctrl+option+command+o
        hotKey = HotKey.register(keyCode: UInt32(kVK_ANSI_O), modifiers: UInt32(cmdKey|optionKey|controlKey), block: {
            self.togglePopover( self )
        })
    }
    
    //this is needed when users ctrl+tab
    func applicationWillResignActive(_ aNotification: Notification) {
        self.statusItem.button?.highlight(false)
        if self.popover.isShown{
            self.closePopover( self )
        }
    }
    
    
    
    func handleAction(_ sender:AnyObject){
        
        let event:NSEvent! = NSApp.currentEvent!
        
        //mouse up instead of down
        //otherwise when you click on a menu, then you have to click twice to make
        //the app react
        if(event.type == .rightMouseUp){
            closePopover(sender, false)
            statusItem.popUpMenu(menu)
        }
        
    }
    
    
    func printQuote(_ sender:AnyObject){
    
        let quoteText = "This is today"
        let quoteAuthor = "Mark"
        
        print("\(quoteText) - \(quoteAuthor)")
    
        
        statusItem.button?.highlight(false)
        statusItem.menu = nil
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
    
    func closePopover(_ sender:AnyObject?, _ deactivate_button:Bool = true){
        
        popover.performClose(sender)
        if deactivate_button {
            self.statusItem.button?.highlight(false)
        }
    }
    
    func togglePopover(_ sender:AnyObject?){
        
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
