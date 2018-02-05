//
//  ConnectionBuilder.swift
//  BridgeBuilder
//
//  Created by Ryan Bergamini on 1/23/18.
//  Copyright © 2018 Underdog Technologies. All rights reserved.
//

import Foundation

class ConnectionBuilder
{
    private var profile: Profile
    private var dateCreated: String
    private var value: Int
    private var connectionId: String
    private var history: [ConnectionRecord]?
    
    init(_ profile: Profile)
    {
        self.profile = profile
        self.dateCreated = Date().description
        self.value = 0
        self.connectionId = "NA"
        self.history = nil
    }
    
    func setDateCreated(_ date: String) -> ConnectionBuilder
    {
        self.dateCreated = date
        
        return self
    }
    
    func setValue(_ value: Int) -> ConnectionBuilder
    {
        self.value = value
        
        return self
    }
    
    func setConnectionId(_ connectionId: String) -> ConnectionBuilder
    {
        self.connectionId = connectionId
        
        return self
    }
    
    func setHistory(_ history: [ConnectionRecord]) -> ConnectionBuilder
    {
        self.history = history
        
        return self
    }
    
    func build() -> Connection
    {
        return Connection(ofId:connectionId, with:profile, on:dateCreated, currentValue:value, withHistory:history)
    }
}
