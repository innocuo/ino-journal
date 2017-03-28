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
    override func draw(_ rect: CGRect) {
        NSColor.white.set()
        NSRectFill(self.bounds)
    }
}
