//
//  SimpleRectangle.swift
//  InoJournal
//
//  Created by Luis Orozco on 3/27/17.
//  Copyright © 2017 Luis Orozco. All rights reserved.
//

import Foundation
import Cocoa

class SimpleRectangle: NSView{
    
    var mainColor: NSColor = NSColor.white
    
    
    override func draw(_ rect: CGRect) {
        
        mainColor.set()
        self.bounds.fill()
    }
    
    
    func updateColor( r: CGFloat, g: CGFloat, b: CGFloat){
        
        mainColor = NSColor(red: r, green: g, blue: b, alpha: 1.0)
        self.setNeedsDisplay( self.bounds )
    }
}
