//
//  HistoricalMultiplierAlgorithm.swift
//  BridgeBuilder
//
//  Created by Ryan Bergamini on 1/10/18.
//  Copyright © 2018 Underdog Technologies. All rights reserved.
//

import Foundation

class HistoryMultiplierAlgorithm : HistoryMultiplierProtocol
{
    private var connection: Connection!
    // The parameters for this constructor are the factors being taken into account
    init(connection: Connection)
    {
        self.connection = connection
    }
    
    func calculateMultiplier() -> Float
    {
        return 1.0
    }
}
