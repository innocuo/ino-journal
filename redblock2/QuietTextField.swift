//
//  QuietViewController.swift
//  InoJournal
//
//  Created by Luis Orozco on 3/19/17.
//  Copyright © 2017 Luis Orozco. All rights reserved.
//
import Cocoa
import Carbon

class QuietTextField: NSTextView {
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    
    override func keyDown(with event: NSEvent) {
        
        //let    modifiers :uint32 = GetCurrentKeyModifiers();
        //Swift.print(modifiers)
       
        //when command return is pressed
        if event.keyCode == 36 && event.modifierFlags.intersection(
            NSEvent.ModifierFlags.deviceIndependentFlagsMask) == NSEvent.ModifierFlags.command {
            self.doCommand(by: #selector(JournalViewController.doSaveEntry))
            return
        }
        super.keyDown(with: event)
        
    }
    
}
