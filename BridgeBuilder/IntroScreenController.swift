//
//  IntroScreenController.swift
//  BridgeBuilder
//
//  Created by Ryan Bergamini on 12/9/17.
//  Copyright © 2017 Underdog Technologies. All rights reserved.
//

import Foundation

enum LogInState
{
    case Loading
    case LoggedIn(LoggedInUserInfo)
    case Error(LogInErrorInfo)
    case LoggedOut
}

protocol LoggedInUserInfo: class
{
    var firstName: String { get }
    var lastName: String { get }
}

protocol LogInErrorInfo: class
{
    var message: String {get}
}

protocol IntroScreenHandler: class
{
    var delegate: IntroScreenDelegate? {get set}
    func logIn(withEmail email: String, password pword: String)
    func logOut()
}

protocol IntroScreenDelegate: class
{
    var logInState: LogInState {get set}
}

class IntroScreenController : IntroScreenHandler
{

    var delegate: IntroScreenDelegate?

    internal func logIn(withEmail email: String, password pword: String)
    {
        if delegate == nil
        {
            fatalError("LoginScreenDelegate not connected")
        }
        
        delegate!.logInState = .Loading
        
        let successResponse: (Profile) -> () = { [unowned self] (profile) in
            print("success \(profile.firstName)")
            self.delegate!.logInState = .LoggedIn(profile) }
        let errorResponse: (Error) -> () = { [unowned self] (error) in
            print("failure \(error.message)")
            self.delegate!.logInState = .Error(error) }
        
        database!.signIn(withEmail: email,password: pword, successResponse:successResponse, errorResponse:errorResponse)
    }
    
    internal func logOut()
    {
        database!.logOut()
        self.delegate!.logInState = .LoggedOut
    }
    
}
