//
//  QuietScroller.swift
//  InoJournal
//
//  Created by Luis Orozco on 3/24/17.
//  Copyright © 2017 Luis Orozco. All rights reserved.
//

import Cocoa

class QuietScroller: NSScroller {
    
    override func draw(_ dirtyRect: NSRect) {
        NSColor(red:0, green:0, blue: 0, alpha:0.2).set()
        super.draw(dirtyRect)
    }
}

