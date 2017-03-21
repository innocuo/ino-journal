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
            print("look for db path: " + DbManager.getDocumentsDirectory().appendingPathComponent( "db.sqlite3" ).absoluteString)
            self.db =  try Connection(DbManager.getDocumentsDirectory().appendingPathComponent( "db.sqlite3" ).absoluteString)
            print ("db inited")
            
            let entries = Table("entries")
            let id = Expression<Int64>("id")
            let entry = Expression<String>("entry")
            let date = Expression<Int64>("date")
            
            try self.db!.run(entries.create(ifNotExists:true){
                t in
                t.column(id, primaryKey: true)
                t.column(entry)
                t.column(date)
            })
            
            #if DEBUG
                self.db!.trace({ (a : String) in print( a ) })
            #endif

        }catch{
            print ("error connecting to db")
            return nil
        }
    }
    
    func addEntry( qtext:String, qdate:Int64) throws -> Int64{
        
        let entries = Table("entries")
        let entry = Expression<String>("entry")
        let date = Expression<Int64>("date")
        
        let insert = entries.insert(
            entry <- qtext,
            date <- qdate
        )
        let rowid = try self.db!.run( insert )
        
        return rowid
    }
    
    func getEntry(_ qoffset:Int) throws -> Row{
        let entries = Table("entries")
        let date = Expression<Int64>("date")
        let query = entries.order(date.desc)
            .limit(1, offset: qoffset)
        
        return try self.db!.pluck(query)!
    }
    
    func getEntriesCount() throws -> Int{
        let entries = Table("entries")
        return try self.db!.scalar(entries.count)
    }
    
    private class func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        print(documentsDirectory)
        return documentsDirectory
    }
}
