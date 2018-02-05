//
//  HomeScreenController.swift
//  BridgeBuilder
//
//  Created by Ryan Bergamini on 12/27/17.
//  Copyright © 2017 Underdog Technologies. All rights reserved.
//

import Foundation

protocol HomeScreenHandler
{
    var currentUser: Profile { get }
    var connections: [Connection] { get }
    var delegate: HomeScreenDelegate? {get set}
    
}

protocol HomeScreenDelegate
{
    func displayConnection(_ connection: Connection)
}

class HomeScreenController : HomeScreenHandler
{
    var connections: [Connection]
    var currentUser: Profile
    var delegate: HomeScreenDelegate?
    
    init()
    {
        if let current = database!.currentUser
        {
            self.currentUser = current
            self.connections = [Connection]()
            retrieveConnections(forUser:currentUser)
        }
        else
        {
            fatalError("No current user")
        }
    }
    
    func retrieveConnections(forUser user: Profile)
    {
        print("called retrieve connections")
        database!.fetchConnections(forUser: user) { [unowned self] (connection) in
            print("Connection with \(connection.profile.firstName)")
            self.addConnection(connection)
        }
    }
    
    private func addConnection(_ connection: Connection)
    {
        self.connections.append(connection)
        
        guard let delegate = self.delegate else
        {
            fatalError("HomeScreenDelegate has not been set")
        }
        
        delegate.displayConnection(connection)
    }
}
