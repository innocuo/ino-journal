//
//  DbManager.swift
//  Quiet
//
//  Created by Luis Orozco on 8/17/16.
//  Copyright © 2017 Luis Orozco. All rights reserved.
//

import SQLite

class DbManager{
    
    let db : Connection?
    
    init?(){
        print("db manager is going to init");
        
        do{
            self.db =  try Connection("/Users/lorozco/Documents/db.sqlite3")
            print ("db inited")
            
            let entries = Table("entries")
            let id = Expression<Int64>("id")
            let entry = Expression<String>("entry")
            
            try self.db!.run(entries.create(ifNotExists:true){
                t in
                t.column(id, primaryKey: true)
                t.column(entry)
            })
        }catch{
            print ("error connecting to db")
            return nil
            
        }
    }
    
    func addEntry(_ text:String) throws -> Int64{
        let entries = Table("entries")
        let insert = entries.insert( Expression<String>("entry") <- text)
        let rowid = try self.db!.run(insert)
        
        return rowid
    }
}
