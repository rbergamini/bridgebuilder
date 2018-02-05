//
//  Connection.swift
//  BridgeBuilder
//
//  Created by Ryan Bergamini on 12/27/17.
//  Copyright © 2017 Underdog Technologies. All rights reserved.
//

import Foundation

// #SketchPractice Do you use getters or public instance variables for Swift
// #SketchPractice Could redesign here so that you don't have to load every profile for every connection

protocol ConnectionRecordProtocol
{
    func getPrompt() -> String
    func getIsAConnection() -> Bool
    func getConnectionResponse() -> String?
    func getAddedValue() -> Int
}

class Connection
{
    private(set) var profile: Profile
    private(set) var dateCreated: String
    private(set) var value: Int
    var connectionId: String
    private(set) var history: [ConnectionRecord]?
    
    public var description: String { return "CID: \(connectionId) Profile: \(profile.description) Created: \(dateCreated) Value: \(value)" }
    
    
    init(ofId connectionId: String, with otherProfile: Profile, on dateCreated: String, currentValue value: Int, withHistory history: [ConnectionRecord]?)
    {
        self.connectionId = connectionId
        self.profile = otherProfile
        self.dateCreated = dateCreated
        self.value = value
        self.history = history
    }
    
    convenience init(with profile: Profile)
    {
        self.init(ofId:"NA",with:profile,on: Date().description,currentValue:0,withHistory:nil)
    }
    
    func addHistory(_ record: ConnectionRecord)
    {
        self.history?.append(record)
    }
    
    func addValue(_ points: Int)
    {
        value += points
    }
}
