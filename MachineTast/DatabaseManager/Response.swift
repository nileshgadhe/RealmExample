//
//  Response.swift
//  MachineTast
//
//  Created by Nilesh Gadhe on 03/02/21.
//  Copyright © 2021 Demo. All rights reserved.

import Foundation

class Response {

    // MARK:- Variables
    
    var message: String?
    var status: Bool?
    var responseObject: AnyObject?
    
    
    // MARK:- Initializers
    
    init(withStatus stts : Bool?, message msg : String?, andResponseObject respObject : AnyObject?) {
        
        self.status = stts
        self.message = msg
        self.responseObject = respObject
        
    }
    
}
