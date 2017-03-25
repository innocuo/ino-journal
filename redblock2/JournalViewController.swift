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
    
    @IBOutlet var textLabel:NSTextField!
    @IBOutlet var textField:NSTextView!
    @IBOutlet var saveBtn:NSButton!
    @IBOutlet var scrollable:NSScrollView!

    let quotes = Quote.all
    let dbmanager = DbManager()
    
    private var backgroundView:JournalBackground?
    private var delegate:AppDelegate?
    
    var currentQuoteIndex: Int = 0{
        didSet{
            updateQuote()
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        if let frameView = self.view.window?.contentView?.superview {
            if backgroundView == nil {
                backgroundView = JournalBackground(frame: frameView.bounds)
                backgroundView!.autoresizingMask = NSAutoresizingMaskOptions([.viewWidthSizable, .viewHeightSizable]);
                frameView.addSubview(backgroundView!, positioned: NSWindowOrderingMode.below, relativeTo: frameView)
            }
        }
        
        textField.delegate = self
        textField.textColor = NSColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1)
        textField.textContainerInset = NSSize(width:10, height: 10)
        currentQuoteIndex = 0
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //self.view.wantsLayer = true
        
        print("view did load")
        
        textField.becomeFirstResponder()
        
        //let color : CGColorRef = CGColorCreateGenericRGB(1.0, 1.0, 1.0, 1.0)
        //self.view.layer?.backgroundColor = color
    }
    
    override func viewDidAppear() {
        
        super.viewDidAppear()
        NSApp.activate(ignoringOtherApps: true)
        textField.nextKeyView = saveBtn
        
        //print("view did appear")
        self.view.window!.makeFirstResponder(textField)
    }
    
    func setDelegate(_ delegate:AppDelegate){
        self.delegate = delegate
    }
    
    func doSaveEntry(){
        
        let str:String = (textField.textStorage as NSAttributedString!).string
        do{
            let timestamp:Int64 = Int64(Date().timeIntervalSince1970)
            let id: Int64 = try dbmanager!.addEntry( qtext:str, qdate: timestamp )
            if(id > 0){
                textField.textStorage?.setAttributedString(NSAttributedString(string: ""))
                
                JournalNotification.shared.send("InoJournal", informativeText: "New entry saved: " + str)
                self.delegate!.closePopover(self)            }
        }catch{
            JournalNotification.shared.send("InoJournal", informativeText: "Entry could not be saved!")
        }
    }


    
    func updateQuote(){
        
        do{
            let row = try dbmanager!.getEntry( currentQuoteIndex )
            let entry = Expression<String>("entry")
            textLabel.stringValue = row[entry]
        }catch{
            
        }
        //textLabel.stringValue = String(describing: quotes[currentQuoteIndex])
    }
    
    func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        print(commandSelector)
        if commandSelector == #selector(NSResponder.insertTab(_:)) && textView == self.textField {
            self.view.window!.makeFirstResponder(self.saveBtn)
            return true
        }else if commandSelector == #selector(self.doSaveEntry) && textView == self.textField{
            print("et voila")
            // self.doSaveEntry()
        }
        return false
    }

    override func keyDown(with theEvent: NSEvent) {
        super.keyDown(with: theEvent)
        print("key down: \(theEvent.keyCode)" )
    }
    
    override func cancelOperation(_ sender: Any?) {
        
        textField.textStorage?.setAttributedString(NSAttributedString(string: ""))
        self.delegate!.closePopover(self)
    }
    
    override func awakeFromNib() {
        print ("layer")
        
    }
}

extension JournalViewController{
    @IBAction func goLeft(_ sender: NSButton){
        do{
            let count = try self.dbmanager!.getEntriesCount()
        currentQuoteIndex = (currentQuoteIndex-1+count)%count
        }catch{
            currentQuoteIndex = 0
        }
    }
    @IBAction func goRight(_ sender: NSButton){
        do{
            let count = try self.dbmanager!.getEntriesCount()
            currentQuoteIndex = (currentQuoteIndex+1)%count
        }catch{
            currentQuoteIndex = 0
        }
    }
    @IBAction func quit(_ sender: NSButton){
        NSApplication.shared().terminate(sender)
    }
    
    @IBAction func saveEntry(_ sender:NSButton){
        doSaveEntry()
    }
}

class JournalBackground:NSView{
    override func draw(_ dirtyRect:NSRect){
        NSColor.white.set()
        NSRectFill(self.bounds)
    }
}
