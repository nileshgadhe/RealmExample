//
//  MatchesModel.swift
//  MachineTast
//
//  Created by Nilesh Gadhe on 03/02/21.
//  Copyright © 2021 Demo. All rights reserved.
//

import Foundation


import RealmSwift

class MatchesModel : Object{
    
    @objc dynamic var matchId : String?
    @objc dynamic var matchName : String?
    
    override class func primaryKey() -> String? {
        return "matchId"
    }

}
