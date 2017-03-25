//
//  JournalNotification.swift
//  InoJournal
//
//  Created by Luis Orozco on 3/25/17.
//  Copyright © 2017 Luis Orozco. All rights reserved.
//

import Foundation

class JournalNotification: NSObject, NSUserNotificationCenterDelegate{
    
    static let shared = JournalNotification()
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
    }
    
    func send(_ title: String, informativeText: String){
        
        let noti = NSUserNotification()
        
        noti.identifier = "\(NSDate().timeIntervalSince1970)"
        noti.title = title
        noti.informativeText = informativeText
        NSUserNotificationCenter.default.deliver(noti)
    }
}
