//
//  HotKey.swift
//  redblock2
//
//  Created by Luis Orozco on 3/19/17.
//  Copyright © 2017 Luis Orozco. All rights reserved.
//

import Cocoa
import Carbon

class HotKey{
    
    private let hotKey: EventHotKeyRef
    private let eventHandler: EventHandlerRef;
    private var registered = true;
    
    init(hotKey: EventHotKeyRef, eventHandler: EventHandlerRef){
        self.hotKey = hotKey
        self.eventHandler = eventHandler
    }
    
    static func register( keyCode: UInt32, modifiers: UInt32, block: @escaping ()->()) -> HotKey?{
        var hotKey: EventHotKeyRef? = nil
        var eventHandler: EventHandlerRef? = nil
        let hotKeyID = EventHotKeyID(signature: 1, id: 1)
        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        
        let ptr = UnsafeMutablePointer<() -> ()>.allocate(capacity: 1)
        ptr.initialize(to: block)
        
        let hotkey_callback:EventHandlerUPP = {(_: OpaquePointer?, _: OpaquePointer?, ptr: UnsafeMutableRawPointer?) -> OSStatus in
            
            guard let pointer = ptr else { fatalError() }
            UnsafeMutablePointer<() -> ()>(OpaquePointer(pointer)).pointee()
            return noErr
        }
    
        
       
        guard InstallEventHandler(GetApplicationEventTarget(), hotkey_callback, 1, &eventType, ptr, &eventHandler) == noErr &&
            RegisterEventHotKey(keyCode, modifiers, hotKeyID, GetApplicationEventTarget(), OptionBits(0), &hotKey) == noErr else {return nil}
        return HotKey(hotKey: hotKey!, eventHandler: eventHandler!)
    }
    
    func unregister() {
        guard registered else {return}
        UnregisterEventHotKey(hotKey)
        RemoveEventHandler(eventHandler)
        registered = false
    }

 }
