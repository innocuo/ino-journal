//
//  AppDelegate.swift
//  InoJournal
//
//  Created by Luis Orozco on 3/19/17.
//  Copyright © 2017 Luis Orozco. All rights reserved.
//

import Cocoa
import Carbon
import Willow

let log = Logger()

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
    let popover = NSPopover()
    
    private var button:NSStatusBarButton?
    
    var eventMonitor: EventMonitor!
    private var hotKey: HotKey?
    
    //MARK: Application

    func applicationDidFinishLaunching(_ notification: Notification) {
        
        //create menu bar icon button
        self.button = statusItem.button!
        if ((self.button) != nil) {
            let img = NSImage(named: "StatusBarButtonImage")
            img?.isTemplate = true
            
            self.button?.target = self
            self.button?.image = img
            
            self.button?.toolTip="InoJournal"
            
        }
        
        //this is the popup where you enter journal entries
        let journalView:JournalViewController = JournalViewController(nibName: "JournalViewController", bundle: nil)!
        journalView.setDelegate(self)
        
        popover.contentViewController = journalView
        popover.animates = false
        //NSAppearance(named: <#T##String#>)
        popover.appearance = NSAppearance( named: NSAppearanceNameAqua )
        
        //this is needed for when user clicks on another statusItem
        eventMonitor = EventMonitor(mask: [.rightMouseUp , .leftMouseUp]) { [unowned self] event in
            print("event monitor event happened")
            if self.popover.isShown{
               self.closePopover(event)
            }
        }
        
        //hot key is ctrl+option+command+o
        hotKey = HotKey.register(keyCode: UInt32(kVK_ANSI_O), modifiers: UInt32(cmdKey|optionKey|controlKey), block: {
            self.togglePopover( self )
        })
        
        //use a delegate so notifications are always visible
        NSUserNotificationCenter.default.delegate = JournalNotification.shared
    }
    
    
    //we should start event monitor only when the app is active,
    //otherwise it's always listening. Creepy af! :)
    func applicationWillBecomeActive(_ notification: Notification) {
        
        eventMonitor.start()
    }
    
    
    //this is needed when users ctrl+tab
    func applicationWillResignActive(_ notification: Notification) {
        
        self.statusItem.button?.highlight(false)
        if self.popover.isShown{
            self.closePopover( self )
        }
        eventMonitor.stop()
    }
    
    
    func applicationWillTerminate(_ notification: Notification) {
        
        if let hk = hotKey {hk.unregister()}
    }
    
    
    func quitApp(_ sender:AnyObject?){
        
        NSApplication.shared().terminate(self)
    }
    
    
    //convenience constructor to be called from other classes
    static func shared() -> AppDelegate
    {
        print("get app delegate")
        return NSApplication.shared().delegate as! AppDelegate
    }
    
    //MARK: Popover display
    
    func showPopover(_ sender:AnyObject?){
        
        if let button = statusItem.button{
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            statusItem.button?.highlight(true)
            
            let img = NSImage(named: "StatusBarButtonImageOn")
            img?.isTemplate = true
            self.button?.image = img
        }
    }
    
    
    func closePopover(_ sender:AnyObject?, _ deactivate_button:Bool = true){
        
        if button != nil{
            let img = NSImage(named: "StatusBarButtonImage")
            img?.isTemplate = true
            self.button?.image = img
        }
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
    
}


extension NSStatusBarButton {
    
    open override func mouseDown( with event: NSEvent) {
        
        //if (event.modifierFlags.contains(NSControlKeyMask)) {
        //   self.rightMouseDown(event)
        //return
        //}
        self.toggle( self.target as? AppDelegate)
    }
    
    open override func rightMouseDown(with event: NSEvent) {
        
        self.toggle( self.target as? AppDelegate)
    }
    
    func toggle(_ delegate:AppDelegate?){
        
        self.highlight(true)
        delegate?.togglePopover(self)
    }
}
