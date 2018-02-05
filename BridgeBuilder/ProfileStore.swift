//
//  ProfileStore.swift
//  BridgeBuilder
//
//  Created by Ryan Bergamini on 6/17/17.
//  Copyright © 2017 Duke Innovation CoLab. All rights reserved.
//

class ProfileStore
{
    var allProfiles = [Profile]();
    
    @discardableResult func createProfile() -> Profile
    {
        let newProfile = Profile(random:true)
        allProfiles.append(newProfile)
        
        return newProfile
    }
    
    @discardableResult func addProfile(_ name: String, _ answer1: String,_ uid: String) -> Profile
    {
        let newProfile = Profile(name,answer1,uid)
        allProfiles.append(newProfile)
        
        return newProfile
    }
}
