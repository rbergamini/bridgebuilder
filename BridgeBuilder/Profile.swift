//
//  Profile.swift
//  BridgeBuilder
//
//  Created by Ryan Bergamini on 6/17/17.
//  Copyright © 2017 Duke Innovation CoLab. All rights reserved.
//

import UIKit


class Profile: LoggedInUserInfo
{
    static let NOVALUE: String = "nO_VaLuE"
    static let UNREGISTERED: String = "UnRegistered"
    var firstName: String
    var lastName: String
    var uid: String
    var email: String
    
    var description: String { return "\(firstName) \(lastName) \(uid)" }
    
    init(_ fname: String,_ lname: String, _ uid: String)
    {
        self.firstName = fname
        self.lastName = lname
        self.uid = uid
        self.email = Profile.UNREGISTERED
    }
    
    convenience init(_ fname: String, _ lname: String, uid: String, email:String)
    {
        self.init(fname,lname,uid)
        self.email = email
    }
    
}
