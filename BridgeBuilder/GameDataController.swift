//
//  GameController.swift
//  BridgeBuilder
//
//  Created by Ryan Bergamini on 1/7/18.
//  Copyright © 2018 Underdog Technologies. All rights reserved.
//

import Foundation

protocol GameDataHandler
{
    func addPoints(_ points: Int)
    func addHistory(_ connectionRecord: ConnectionRecord)
    func calculateHistoricalMultiplier() -> Float
    func endGame() -> Connection
}

protocol HistoryMultiplierProtocol
{
    func calculateMultiplier() -> Float
}

class GameDataController : GameDataHandler
{
    private var connection: Connection!
    private var connectionHistory: [ConnectionRecord]!
    
    init(_ connection: Connection)
    {
        self.connection = connection
        self.connectionHistory = [ConnectionRecord]()
    }
    
    func addPoints(_ points: Int)
    {
        connection.addValue(points)
    }
    
    func addHistory(_ connectionRecord: ConnectionRecord)
    {
        connection.addHistory(connectionRecord)
    }
    
    func calculateHistoricalMultiplier() -> Float
    {
        let multiplierEngine: HistoryMultiplierProtocol = HistoryMultiplierAlgorithm(connection:connection)
        return multiplierEngine.calculateMultiplier()
    }
    
    func endGame() -> Connection
    {
        return connection
    }
}
