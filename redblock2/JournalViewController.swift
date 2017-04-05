//
//  QuietViewController.swift
//  InoJournal
//
//  Created by Luis Orozco on 3/19/17.
//  Copyright © 2017 Luis Orozco. All rights reserved.
//

import Cocoa
import SQLite

class JournalViewController: NSViewController, NSTextViewDelegate{
    
    @IBOutlet var displayedEntry:NSTextField!
    @IBOutlet var displayedDate: NSTextField!
    @IBOutlet var textCount: NSTextField!
    @IBOutlet var textField: NSTextView!
    @IBOutlet var saveBtn: NSButton!
    @IBOutlet var scrollable: NSScrollView!
    @IBOutlet var displayBG: SimpleRectangle! //bottom panel

    let dbmanager = DbManager()
    
    let settingsMenu:NSMenu = NSMenu()
    
    private var backgroundView:JournalBackground?
    private var delegate:AppDelegate?
    
    var currentDisplayedIndex: Int = 0{
        didSet{
            updateDisplayedEntry()
        }
    }
    
    //MARK: View
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        print ("view will appear")
        
        if let frameView = self.view.window?.contentView?.superview {
            if backgroundView == nil {
                backgroundView = JournalBackground(frame: frameView.bounds)
                backgroundView!.autoresizingMask = NSAutoresizingMaskOptions([.viewWidthSizable, .viewHeightSizable]);
                frameView.addSubview(backgroundView!, positioned: NSWindowOrderingMode.below, relativeTo: frameView)
            }
        }
        
        currentDisplayedIndex = 0
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print ("view did load")
        
        settingsMenu.addItem(NSMenuItem(title: "Quit", action: #selector(AppDelegate.quitApp(_:)), keyEquivalent: "q"))
        
        displayBG.updateColor(r: 240/255, g: 242/255, b: 238/255)
        
        textField.delegate = self
        //textField.textColor = NSColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
        textField.textContainerInset = NSSize(width:7, height: 0)
        textField.becomeFirstResponder()
    
    }
    
    
    override func viewDidAppear() {
        
        super.viewDidAppear()
       
        //this is necessary for when you use the hotkey,
        //otherwise it doesn't focus on the text field
        //Also needed so clicks outside the app trigger events to
        //close the popover
        NSApp.activate(ignoringOtherApps: true)
        
        self.view.window!.makeFirstResponder(textField)
    }
    
    
    //press the ESC key to close the panel
    override func cancelOperation(_ sender: Any?) {
        
        resetTextField()
        self.delegate!.closePopover(self)
    }
    
    
    func setDelegate(_ delegate:AppDelegate){
        
        self.delegate = delegate
    }
    
    
    //MARK: Entries
    
    
    func doSaveEntry(){
        
        let str:String = (textField.textStorage as NSAttributedString!).string
        
        if str.characters.count <= 0{
            return
        }
        
        do{
            let timestamp:Int64 = Int64(Date().timeIntervalSince1970)
            let id: Int64 = try dbmanager!.addEntry( qtext:str, qdate: timestamp )
            if(id > 0){
                //textField.textStorage?.setAttributedString(NSAttributedString(string: ""))
                resetTextField()
                JournalNotification.shared.send("InoJournal", informativeText: "New entry saved: " + str)
                self.delegate!.closePopover(self)            }
        }catch{
            JournalNotification.shared.send("InoJournal", informativeText: "Entry could not be saved!")
        }
    }


    func updateDisplayedEntry(){
        
        do{
            let row = try dbmanager!.getEntry( currentDisplayedIndex )
            let entry = Expression<String>("entry")
            let date = Expression<Int64>("date")
            
            let ts = row[ date ]
            let realDate = Date(timeIntervalSince1970: TimeInterval(ts) )
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "MMM dd YYYY - hh:mm a"
            
            displayedEntry.stringValue = row[entry]
            displayedDate.stringValue = dateFormat.string(from: realDate)
        }catch{
            
        }
    }
    
    //MARK: Text field
    
    
    //from NSTextViewDelegate
    //self is added as delegate of the text field, so self will receive commands
    //from the text field
    func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        
        //if tab is pressed in text field, focus on saved button
        //used because without it, the tab is entered as part of the text
        //This is also why textField.nextKeyView = saveBtn would be useless
        if commandSelector == #selector(NSResponder.insertTab(_:)) && textView == self.textField {
            self.view.window!.makeFirstResponder( saveBtn )
            return true
        }
        
        //a command used in QuietTextField is JournalViewController.doSaveEntry, 
        //if we wanted to use it here, we can do
        //commandSelector == #selector(self.doSaveEntry)
        
        return false
    }
    
    
    //from NSTextViewDelegate
    func textDidChange(_ notification: Notification) {
        
        let count = textField.string!.characters.count
        textCount.stringValue = "\( count )"
        
        if count>0 {
            saveBtn.isEnabled = true
        }else{
            saveBtn.isEnabled = false
        }
    }
    
    
    func resetTextField(){
        
        textField.string = ""
        textCount.stringValue = "0"
        saveBtn.isEnabled = false
    }
}

extension JournalViewController{
    
    //use arrow buttons to display previous/next entries
    @IBAction func navigate(_ sender: NSSegmentedControl){
        
        do{
            
            let count = try self.dbmanager!.getEntriesCount()
            
            //the next(forward) button actually shows older entries
            let dir: Int = sender.selectedSegment == 0 ? -1 + count : 1;
            currentDisplayedIndex = ( currentDisplayedIndex + dir ) % count
            
        }catch{
            
            currentDisplayedIndex = 0
        }
    }
    
    
    @IBAction func saveEntry(_ sender:NSButton){
        
        doSaveEntry()
    }
    
    
    @IBAction func settings(_ sender: NSButton){
        
        if let event = NSApplication.shared().currentEvent {
            NSMenu.popUpContextMenu( settingsMenu, with: event, for: sender)
        }
    }
}

class JournalBackground:NSView{
    override func draw(_ dirtyRect:NSRect){
        NSColor(red: 85/255, green: 205/255, blue: 240/255, alpha: 1.0).set()
        NSRectFill(self.bounds)
    }
}
