//
//  LogConfiguration.swift
//  InoJournal
//
//  Created by Luis Orozco on 4/11/17.
//  Copyright © 2017 Luis Orozco. All rights reserved.
//

import Willow

class LogUtil{
    
    var logger:Logger! = nil
    
    private struct PrefixModifier: LogModifier {
        
        func modifyMessage(_ message: String, with: LogLevel) -> String {
            return "[\(with.description)] \(message)"
        }
    }
    
    public init(){
        logger = createLog()
    }
    
    private func createLog() -> Logger {
        
        let prefixModifiers = [PrefixModifier()]
       
        let writers = [ConsoleWriter(modifiers: prefixModifiers)]
        
        return Logger( logLevels: [.all], writers: writers )
        
    }
    
    func format(_ message: String,_ file: String = #file,_ function: String = #function,_ line: Int = #line) -> String {
       
        let filename =  (file as NSString).lastPathComponent
        
        return "\(message) | \(filename):\(line) \(function)"
    }
    
    func debug(_ message: String, _ file: String = #file, _ function: String = #function, _ line: Int = #line){
        logger.debugMessage( self.format( message, file, function, line) )
    }
    
    func error(_ message: String, _ file: String = #file, _ function: String = #function, _ line: Int = #line){
        logger.errorMessage( self.format( message, file, function, line) )
    }
    
    func event(_ message: String, _ file: String = #file, _ function: String = #function, _ line: Int = #line){
        logger.eventMessage( self.format( message, file, function, line) )
    }
}

