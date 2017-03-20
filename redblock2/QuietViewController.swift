//
//  QuietViewController.swift
//  redblock2
//
//  Created by Luis Orozco on 3/19/17.
//  Copyright © 2017 Luis Orozco. All rights reserved.
//

import Cocoa

class QuietViewController: NSViewController, NSTextViewDelegate{
    
    @IBOutlet var textLabel:NSTextField!
    @IBOutlet var textField:NSTextView!
    @IBOutlet var saveBtn:NSButton!

    let quotes = Quote.all
    let dbmanager = DbManager()
    
    private var backgroundView:QuietBackground?
    private var delegate:AppDelegate?
    
    var currentQuoteIndex: Int = 0{
        didSet{
            updateQuote()
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        print("megasaur")
        if let frameView = self.view.window?.contentView?.superview {
            if backgroundView == nil {
                backgroundView = QuietBackground(frame: frameView.bounds)
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
        
        
        print("view did appear")
        print(self.view.window!.makeFirstResponder(textField))
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
                
                print("New Entry Saved, id: " + String(id) )
                self.delegate!.closePopover(self)
            }
        }catch{
            print("Entry could not be saved")
        }
    }


    
    func updateQuote(){
        
        textLabel.stringValue = String(describing: quotes[currentQuoteIndex])
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
        print(theEvent.keyCode )
    }
    
    override func awakeFromNib() {
        print ("layer")
        
    }
}

extension QuietViewController{
    @IBAction func goLeft(_ sender: NSButton){
        currentQuoteIndex = (currentQuoteIndex-1+quotes.count)%quotes.count
    }
    @IBAction func goRight(_ sender: NSButton){
        currentQuoteIndex = (currentQuoteIndex+1)%quotes.count
    }
    @IBAction func quit(_ sender: NSButton){
        NSApplication.shared().terminate(sender)
    }
    
    @IBAction func saveEntry(_ sender:NSButton){
        doSaveEntry()
    }
}

class QuietBackground:NSView{
    override func draw(_ dirtyRect:NSRect){
        NSColor.white.set()
        NSRectFill(self.bounds)
    }
}
