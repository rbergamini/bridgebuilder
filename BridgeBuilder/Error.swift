//
//  Error.swift
//  BridgeBuilder
//
//  Created by Ryan Bergamini on 12/9/17.
//  Copyright © 2017 Underdog Technologies. All rights reserved.
//

import Foundation


class Error: LogInErrorInfo
{
    var message: String
    
    init(message msg: String)
    {
        message = msg
    }
}
