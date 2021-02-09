//
//  DatabaseManager.swift
//  MachineTast
//
//  Created by Nilesh Gadhe on 03/02/21.
//  Copyright © 2021 Demo. All rights reserved.
//

import Foundation


import Foundation
import RealmSwift

class DatabaseManager {
    
    typealias Completion = (_ response : Response) -> Void
    let realm = try! Realm()
    
    
    // MARK:- Variables
    
    static private var sharedInstance: DatabaseManager!
    private var session: URLSession!
    
    // MARK:- Singleton Class Method
    // Class method which creates a singleton object of DatabaseManager
    // and manages it
    
    class func shared() -> DatabaseManager{
        
        if let store = sharedInstance {
            
            return store
        } else {
            
            sharedInstance = DatabaseManager()
            sharedInstance.session = URLSession.shared
            return sharedInstance
        }

    }


    func insertMatch(match : MatchesModel) -> Bool {
        
        do{
            try realm.write {
                realm.add(match)
            }
          
            return true
        } catch{
            
            return false
        }
    }
    
    func getAllMatches() -> [MatchesModel] {
        
        var result = try! Realm().objects(MatchesModel.self)
        //result = result.sorted(byKeyPath: "createdOnDate", ascending: false)
        
        return result.map({$0 as MatchesModel})
    }
    
    func getMatchOfId(matches : MatchesModel) -> MatchesModel {
        let match = try! realm.object(ofType: MatchesModel.self, forPrimaryKey: matches.matchId)
        return match!
    }
    
    func deleteMatchOfId(matches : MatchesModel) -> Bool{
        let match = realm.object(ofType: MatchesModel.self, forPrimaryKey: matches.matchId)
        do{
            try realm.write {
                realm.delete(match!)
            }
            return true
        } catch{
            
            return false
        }
    }
    
    func shouldInsertMatch(matches : MatchesModel) -> Bool {
        
        let match = realm.objects(MatchesModel.self).filter("matchId == %@", matches.matchId)
        
        do{
            if match.count == 0 {
                return true
            }
            return false
            
        } catch{
            
            return false
        }
        
    }
    
    
}


    


