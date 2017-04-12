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
    
    private struct PrefixModifier: LogMessageModifier {
        
        func modifyMessage(_ message: String, with: LogLevel) -> String {
            return message
        }
    }
    
    public init(){
        logger = createLog()
    }
    
    private func createLog() -> Logger {
        
        let prefixModifier = PrefixModifier()
       
        let modifiers: [  LogLevel : [LogMessageModifier] ] = {
            
            let modifiers: [LogMessageModifier] = [prefixModifier]
            
            return [
                .warn: modifiers,
                .error: modifiers,
                .debug: modifiers
            ]
        }()
        
        let configuration = Willow.LoggerConfiguration( modifiers: modifiers)

        
        return Logger( configuration: configuration )
        
    }
    
    func format(_ message: String,_ file: String = #file,_ function: String = #function,_ line: Int = #line) -> String {
       
        let filename =  (file as NSString).lastPathComponent
        
        return "\(filename):\(line) \(function): \(message)"
    }
    
    func debug(_ message: String, _ file: String = #file, _ function: String = #function, _ line: Int = #line){
        logger.debug( self.format( message, file, function, line) )
    }
    
    func error(_ message: String, _ file: String = #file, _ function: String = #function, _ line: Int = #line){
        logger.error( self.format( message, file, function, line) )
    }
    
    func event(_ message: String, _ file: String = #file, _ function: String = #function, _ line: Int = #line){
        logger.event( self.format( message, file, function, line) )
    }
}

