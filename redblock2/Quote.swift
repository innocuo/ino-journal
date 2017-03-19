//
//  Quote.swift
//  Quiet
//
//  Created by Luis Orozco on 8/2/16.
//  Copyright © 2016 Luis Orozco. All rights reserved.
//

struct Quote{
    let text: String
    let author: String
    
    static let all: [Quote] = [
        Quote(text:"this is quote 1", author:"me"),
        Quote(text:"this is quote 2", author:"you"),
        Quote(text:"this is quote 3", author:"she"),
        Quote(text:"this is quote 4", author:"he"),
        Quote(text:"this is quote 5", author:"not me"),
        Quote(text:"this is quote 6", author:"anonymous"),
        Quote(text:"this is quote 7", author:"everyone")
    ]
}

//MARK: - CustomStringConvertible

extension Quote: CustomStringConvertible{
    var description: String{
        return "\"\(text)\" - \(author)"
    }
}
