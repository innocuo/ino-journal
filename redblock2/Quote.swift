//
//  Quote.swift
//  InoJournal
//
//  Created by Luis Orozco on 8/2/16.
//  Copyright © 2017 Luis Orozco. All rights reserved.
//

struct Quote{
    let text: String
    let author: String
    
    static let all: [Quote] = [
        Quote(text:"Enjoy the little things", author:"me"),
        Quote(text:"The best is yet to come", author:"you"),
        Quote(text:"No excuses", author:"she"),
        Quote(text:"The master has failed more times than the beginner has even tried", author:"he"),
        Quote(text:"One day can change everything", author:"not me"),
        Quote(text:"Life is too short to wait", author:"anonymous"),
        Quote(text:"Stop saying \"I wish\", start saying \"I will\"", author:"everyone")
    ]
}

extension Quote: CustomStringConvertible{
    var description: String{
        return "\"\(text)\" - \(author)"
    }
}
