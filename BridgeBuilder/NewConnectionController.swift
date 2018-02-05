//
//  NewConnectionController.swift
//  BridgeBuilder
//
//  Created by Ryan Bergamini on 1/7/18.
//  Copyright © 2018 Underdog Technologies. All rights reserved.
//

import Foundation


protocol NewConnectionHandler
{
    var delegate: NewConnectionDelegate? {get set}
    func retrieveConnectionWithOldUser(_ completion:  @escaping (Connection) -> ())
    func retrieveConnectionWithNewUser() -> Connection
}

protocol NewConnectionDelegate
{
    func getFirstName() -> String
    func getEmail() -> String
    // func get selfie
}

class NewConnectionController : NewConnectionHandler
{

    var delegate: NewConnectionDelegate?
    
    init()
    {
        
    }
    
    func retrieveConnectionWithOldUser(_ completion: @escaping (Connection) -> ())
    {
        if let email = delegate?.getEmail()
        {
            let errorResponse: (Error) -> () = { (error) in
                fatalError(error.message)
            }
            
            let successResponse: (Profile) -> () = { [unowned self](profile) in
                database?.getOrMakeOldConnection(with: profile, completion: completion, errorResponse: errorResponse)
            }
            
            database?.fetchProfile(fromEmail: email, successResponse: successResponse, errorResponse: errorResponse)
        // Get UID
        // Check if there are any existing connection with UID
        // if(hasConnectionWith(Profile, success(
        // If
            // TRUE: return those already existing connection
            // FALSE: Retrieve Profile data, Create a new connection, return connection
        }
    }
    
    func retrieveConnectionWithNewUser() -> Connection
    {
        var first: String = "ERROR"
        
        if let firstName = delegate?.getFirstName()
        {
            first = firstName
        }
        
        
        let profBuilder = ProfileBuilder()
        profBuilder.setFirstName(first)
        
        let profile = profBuilder.build()
        // Q: Should we assign a unique ID?
        // A: Yes, we can update the UID if the non-registered player wants to connect to their profile later. We just need to make an update UID function that loops through the profile's connections, then updates accordingly
        // Create a new connection in the data base
        let connection = addConnectionToDatabase(profile)
        
        return connection
    }
    
    private func addConnectionToDatabase(_ profile: Profile) -> Connection
    {
        if let db = database
        {
            let prof = db.addProfile(profile)
            let conBuilder: ConnectionBuilder = ConnectionBuilder(profile)
            conBuilder.setDateCreated( Date().description)
            var newConnection: Connection = conBuilder.build()
            newConnection = db.addConnection(newConnection)
            
            return newConnection
        }
        else
        {
            fatalError("Database not initialized")
        }
    }
}
