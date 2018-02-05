//
//  Database.swift
//  BridgeBuilder
//
//  Created by Ryan Bergamini on 12/9/17.
//  Copyright © 2017 Underdog Technologies. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

let FIRSTNAME = "firstName"
let LASTNAME = "lastName"
let USERS = "users"
let CONNECTIONS = "connections"
let DATECREATED = "dateCreated"
let EMAIL = "email"
let EMAILTOUID = "emailToUID"

enum LogInResult
{
    case Failure(Error)
    case Success(Profile)
}

enum DatabaseError
{
    case NoFirstName
    case NoLastName
}

class UTDatabase : DatabaseProtocol
{

    var currentUser: Profile?
    
    init()
    {
        FirebaseApp.configure()
    }
    
    // Login Methods
    func signIn(withEmail email: String, password pword: String, successResponse: @escaping (Profile) -> (), errorResponse: @escaping (Error) -> ())
    {
        Auth.auth().signIn(withEmail:email,password:pword)
        { [unowned self]
            (user, error) in
            if let error = error
            {
                let signInError = Error(message: error.localizedDescription)
                errorResponse(signInError)
            }
            if let user = user
            {
                let usersRef = Database.database().reference().child(USERS).child(user.uid)
               // Set Email to UID reference
                let formattedEmail = self.formatEmailForDatabase(email)
               Database.database().reference().child(EMAILTOUID).child(formattedEmail).setValue(user.uid)
                
                
                usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let firstName = value?[FIRSTNAME] as? String ?? "NoFirstName"
                    let lastName = value?[LASTNAME] as? String ?? "NoLastName"
                    let profile = Profile(firstName,lastName,user.uid)
                    profile.email = email
                    self.currentUser = profile
                    successResponse(profile)
                }) { (error) in
                    errorResponse(Error(message: error.localizedDescription))
                }

            }
        }
    }
    
    // TODO: History, Date, THIS IS A MESS
    func fetchConnections(forUser user: Profile, forEachCompletion: @escaping (Connection) -> ())
    {
        let usersRef = Database.database().reference().child(USERS)
        let connectionsRef = Database.database().reference().child(CONNECTIONS)
        print("before users ref \(user.uid)")
        
        usersRef.child(user.uid).child(CONNECTIONS).observeSingleEvent(of: .value ,with: { [unowned self](snapshot) in
            let value = snapshot.value as? NSDictionary
            print("Dictionary printed \(value) vs \(snapshot.value)")
            
            for (userKey, connectionKey) in value!
            {
                print("\(userKey) \(connectionKey)")
                let uKey: String = userKey as! String
                let conKey: String = connectionKey as! String
                
                self.fetchConnection(withUserId: uKey, connectionId: conKey, forCompletion: forEachCompletion)
                /*
                usersRef.child(uKey).observeSingleEvent(of: .value, with: { [unowned self](uSnapshot) in
                    let uValue = uSnapshot.value as? NSDictionary
                    let profile = self.createProfile(withId:uKey,from:uValue)
                    
                    connectionsRef.child(conKey).observeSingleEvent(of: .value, with: { [unowned self](cSnapshot) in
                        let cValue = cSnapshot.value as? NSDictionary
                        let returnedConnection = self.createConnection(withId:conKey,withProfile: profile,from:cValue)
                        
                        forEachCompletion(returnedConnection)
                        
                    }) { (error) in
                        fatalError("Error in retrieving \(conKey) data in fetchConnections testing in UTDatabase")
                    }
                    
                }) { (error) in
                    fatalError("Error in retrieving \(uKey) data in fetchConnections in UTDatabase")
                }*/
                
            }
        }) { (error) in
            fatalError("Error in fetchConnections in UTDatabase")
        }
    }
    
    private func fetchConnection(withUserId uKey: String, connectionId conKey: String, forCompletion: @escaping (Connection) -> ())
    {
        
        let usersRef = Database.database().reference().child(USERS)
        let connectionsRef = Database.database().reference().child(CONNECTIONS)
        
        usersRef.child(uKey).observeSingleEvent(of: .value, with: { [unowned self](uSnapshot) in
            let uValue = uSnapshot.value as? NSDictionary
            let profile = self.createProfile(withId:uKey,from:uValue)
            
            connectionsRef.child(conKey).observeSingleEvent(of: .value, with: { [unowned self](cSnapshot) in
                let cValue = cSnapshot.value as? NSDictionary
                let returnedConnection = self.createConnection(withId:conKey,withProfile: profile,from:cValue)
                
                forCompletion(returnedConnection)
                
            }) { (error) in
                fatalError("Error in retrieving \(conKey) data in fetchConnections testing in UTDatabase")
            }
            
        }) { (error) in
            fatalError("Error in retrieving \(uKey) data in fetchConnections in UTDatabase")
        }

    }
    
    func logOut()
    {
        try! Auth.auth().signOut()
        currentUser = nil
    }
    
    // Returns a Profile with the generated ID
    func addProfile(_ profile: Profile) -> Profile
    {
        let usersRef = Database.database().reference().child(USERS)
        let values = [FIRSTNAME : profile.firstName, LASTNAME : profile.lastName, EMAIL : formatEmailForDatabase(profile.email)]
        
        
        let newProfileRef = usersRef.childByAutoId()
        newProfileRef.setValue(values)
        profile.uid = newProfileRef.key
        return profile
    }
    
    // Returns a Connection with the generated ID
    func addConnection(_ connection: Connection) -> Connection
    {
        let connectionsRef = Database.database().reference().child(CONNECTIONS)
        let usersRef = Database.database().reference().child(USERS)
        
        let values = [DATECREATED : connection.dateCreated]
        let newConnectionRef = connectionsRef.childByAutoId()
        newConnectionRef.setValue(values)
        connection.connectionId = newConnectionRef.key
        
        // Add Connection To Each Profile
        if let currentId = currentUser?.uid
        {
            let connectionId = connection.connectionId
            let otherId =  connection.profile.uid
            usersRef.child(currentId).child(CONNECTIONS).child(otherId).setValue(connectionId)
            usersRef.child(otherId).child(CONNECTIONS).child(currentId).setValue(connectionId)
        }
        
        return connection
    }
    
    func fetchProfile(fromEmail email: String, successResponse: @escaping (Profile) -> (), errorResponse: @escaping (Error) -> ())
    {
        
        let emailRef = Database.database().reference().child(EMAILTOUID).child(formatEmailForDatabase(email)).observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
            
            let userIdValue = snapshot.value as? String
            
            if let userId = userIdValue
            {
                self.fetchProfile(fromUID: userId, successResponse:successResponse,errorResponse: errorResponse)
            }
            
        });
        
    }
    
    func fetchProfile(fromUID uid: String, successResponse: @escaping (Profile) -> (), errorResponse: @escaping (Error) -> ())
    {
        let usersRef = Database.database().reference().child(USERS).child(uid)
        
        usersRef.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let firstName = value?[FIRSTNAME] as? String ?? "NoFirstName"
            let lastName = value?[LASTNAME] as? String ?? "NoLastName"
            let profile = Profile(firstName,lastName,uid)
            self.currentUser = profile
            successResponse(profile)
        }) { (error) in
            errorResponse(Error(message: error.localizedDescription))
        }
    }
    
    
    // TODO: And the tipping point of "IDGAF" about design and naming has been passed....
    func getOrMakeOldConnection(with profile: Profile, completion: @escaping (Connection) -> (), errorResponse: @escaping (Error) -> ())
    {
        if let user = self.currentUser
        {
            let usersConnectionsRef = Database.database().reference().child(USERS).child(user.uid).child(CONNECTIONS)
            
            usersConnectionsRef.observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
                let value = snapshot.value as? NSDictionary
                let conId = value?[profile.uid] as? String
                
                if let connectionId = conId
                {
                    self.fetchConnection(withUserId: profile.uid, connectionId: connectionId, forCompletion: completion)
                }
                else
                {
                    let builder = ConnectionBuilder(profile)
                    var connection = builder.build()
                    connection = self.addConnection(connection)
                    completion(connection)
                }
                
            }) { (error) in
                errorResponse(Error(message: error.localizedDescription))
            }

        }
        
    }
    
    private func createConnection(withId conId: String, withProfile profile: Profile,from dict: NSDictionary?) -> Connection
    {
        let dateCreated = dict?[DATECREATED] as? String ?? "NoDate"
        
        return Connection(ofId: conId, with: profile, on: dateCreated, currentValue: 0, withHistory: nil)
    }
    
    private func createProfile(withId uid: String, from dict: NSDictionary?) -> Profile
    {
        let firstName = dict?[FIRSTNAME] as? String ?? Profile.NOVALUE
        let lastName = dict?[LASTNAME] as? String ?? Profile.NOVALUE
        let email = dict?[EMAIL] as? String ?? Profile.UNREGISTERED
        let profile = Profile(firstName,lastName,uid:uid,email:formatEmailForApplication(email))
        
        return profile
    }
    
    // Because Firebase can't have '.' in its keys
    private func formatEmailForDatabase(_ email: String) -> String
    {
        return email.replacingOccurrences(of: ".", with: ":^)")
    }
    
    private func formatEmailForApplication(_ email: String) -> String
    {
        return email.replacingOccurrences(of: ":^)", with: ".")
    }
    
    

}
        /*
        usersRef.child(user.uid).child(CONNECTIONS).queryOrderedByKey().observe(.childAdded,with: {
            (snapshot) -> Void in
            
            print("in fetch connections")
            
            let vals: [String:String]? = snapshot.value as? [String:String]
            
            print(vals)
            if let val = vals
            {
                for (key,value) in val
                {
                    print(" content test \(key) \(value)")
                }
            }
            let value = snapshot.value as? NSDictionary
            let otherUsers = value?.allKeys as? [String] ?? []
            
            for  otherUser in otherUsers // Loop through connections
            {
                if let connectId = value?[otherUser] as? String
                {
                
                connectionsRef.child(connectId).observeSingleEvent(of: .value, with: { (data) in
                    let conValue = data.value as? NSDictionary
                    let dateCreated = conValue?[DATECREATED] as? String ?? "Error"
                    
                    
                    usersRef.child(otherUser).observeSingleEvent(of: .value, with: { (otherData) in
                        let otherValue = otherData.value as? NSDictionary
                        let firstName = otherValue?[FIRSTNAME] as? String ?? "NoFirstName"
                        let lastName = otherValue?[LASTNAME] as? String ?? "NoLastName"
                        let profile = Profile(firstName,lastName,user.uid)
                        let connection = Connection(with: profile, on: dateCreated, currentValue: 0, withHistory: nil)
                        
                        forEachCompletion(connection)
                        
                    }){ (error) in
                        print(error.localizedDescription)
                    }
                    
                }){ (error) in
                    print(error.localizedDescription)
                }
                }
            }
        
        })*/
    
    
    /*
    
    // Helper Methods

    func getProfile(fromUID uid: String) -> Profile
    {
        let usersRef = Database.database().reference().child("users").child(uid)
        
        var fName = "NoFirstName"
        var lName = "NoLastName"
        
        // Retrieve All Values
        /*
        if let firstName = usersRef.value(forKey:FIRSTNAME) as? String
        {
            fName = firstName
            //fatalError("No First Name for \(uid)")
        } */
        
        usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let firstName = value?[FIRSTNAME] as? String ?? "NoFirstName"
            let lastName = value?[LASTNAME] as? String ?? "NoLastName"
            
            successResponse(Profile(firstName,lastName, uid))
        }) { (error) in
            errorResponse(Error(message: error.localizedDescription)
        }
        
        /*
        if let lastName = usersRef.value(forKey:LASTNAME) as? String
        {
            lName = lastName
            //fatalError("No Last Name for \(uid)")
        }*/
    
    } */

