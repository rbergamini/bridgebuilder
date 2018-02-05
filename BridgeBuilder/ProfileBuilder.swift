//
//  ProfileBuilder.swift
//  BridgeBuilder
//
//  Created by Ryan Bergamini on 1/23/18.
//  Copyright © 2018 Underdog Technologies. All rights reserved.
//

import Foundation

class ProfileBuilder
{
    private var firstName: String
    private var lastName: String
    private var uid: String
    
    init()
    {
        self.firstName = Profile.NOVALUE
        self.lastName = Profile.NOVALUE
        self.uid = Profile.NOVALUE
    }
    
    func setFirstName(_ first: String) -> ProfileBuilder
    {
        firstName = first
        return self
    }
    
    func setLastName(_ last: String) -> ProfileBuilder
    {
        lastName = last
        return self
    }
    
    func setUID(_ userID: String) -> ProfileBuilder
    {
        uid = userID
        return self
    }
    
    func build() -> Profile
    {
        return Profile(firstName, lastName, uid)
    }
}
