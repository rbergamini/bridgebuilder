//
//  ConnectionRecord.swift
//  BridgeBuilder
//
//  Created by Ryan Bergamini on 12/27/17.
//  Copyright © 2017 Underdog Technologies. All rights reserved.
//

import Foundation


class ConnectionRecord : ConnectionRecordProtocol
{
    private let prompt: String!
    private let isAConnection: Bool!
    private let response: String?
    private let addedValue: Int!
    
    init(prompt: String, madeConnection isAConnection: Bool, response: String, value addedValue: Int)
    {
        self.prompt = prompt
        self.isAConnection = isAConnection
        self.response = response
        self.addedValue = addedValue
    }
    
    func getPrompt() -> String
    {
        return prompt
    }
    
    func getIsAConnection() -> Bool
    {
        return isAConnection
    }
    
    func getConnectionResponse() -> String?
    {
        return response
    }
    
    func getAddedValue() -> Int
    {
        return addedValue
    }
}
