//
//  IntroScreenUIController.swift
//  BridgeBuilder
//
//  Created by Ryan Bergamini on 12/12/17.
//  Copyright © 2017 Underdog Technologies. All rights reserved.
//

import Foundation
import UIKit

/*
 (for reference of the LogInState values) LogInState
 {
 case Loading
 case LoggedIn(LoggedInUserInfo)
 case Error(LogInErrorInfo)
 case LoggedOut
 }
 */

// #SketchPractice Passing the controller as a variable

class IntroScreenUIController : IntroScreenDelegate
{
    var logInState: LogInState = .LoggedOut {
        willSet(newLogInState)
        {
            update(newLogInState)
        }
    }
    private unowned var view: UIView
    private let logInView: LogInView!
    private let displayLabel: UILabel!
    private let logOutButton: UIButton!
    private weak var controller: IntroScreenFunctionalProtocol!
    
    init(view: UIView, controller: IntroScreenFunctionalProtocol)
    {
        self.view = view
        self.controller = controller
        self.displayLabel = UILabel(frame: CGRect(x: 0, y: 200, width: 200, height: 21))
        self.logOutButton = UIButton(frame: CGRect(x:0, y: 300, width: 200, height: 21))
        self.logInView = LogInView(frame: self.view.frame)
        configureLogInView()
        configureDisplayLabel()
        configureLogOutButton()
        
        view.addSubview(logInView)
        view.addSubview(displayLabel)
        view.addSubview(logOutButton)
        
        view.insertSubview(displayLabel, aboveSubview: logInView)
        view.insertSubview(logOutButton, aboveSubview: logInView)
        displayLabel.topAnchor.constraint(equalTo: logInView.bottomAnchor, constant: -30.0).isActive = true;
    }
    
    private func configureDisplayLabel()
    {
        displayLabel.text = "Loading..."
        displayLabel.isHidden = true
        displayLabel.textColor = .red
        
    }
    
    func update(_ newLogInState: LogInState)
    {
        switch(logInState,newLogInState)
        {
            case (.LoggedOut,.Loading): loggedOutToLoading()
            case (.Loading, .Loading): loadingToLoading()
            case (.Loading, .LoggedIn(let profile)): loadingToLoggedIn(profile: profile)
            case (.Loading, .Error(let error)): loadingToError(error: error)
            case (.LoggedIn,.LoggedOut): loggedInToLoggedOut()
            default: //fatalError("Not Yet Implemented Transition from \(logInState) to \(newLogInState)")
            loggedInToLoggedOut()
        }
    }
    
    func loggedOutToLoading()
    {
        
        logInView.contentView.isHidden = true
        displayLabel.text = "Loading"
        displayLabel.isHidden = false

    }
    
    func loadingToLoading()
    {
        displayLabel.text = "Loading"
    }
    
    func loadingToLoggedIn(profile: LoggedInUserInfo)
    {
        displayLabel.text = "Welcome \(profile.firstName) \(profile.lastName)"
        displayLabel.isHidden = false
        logOutButton.isHidden = false
        controller.requestHomeScreen()
    }
    
    func loadingToError(error: LogInErrorInfo)
    {
        logInView.contentView.isHidden = false
        displayLabel.text = error.message
        displayLabel.isHidden = false
    }
    
    func loggedInToLoggedOut()
    {
        displayLabel.isHidden = true
        logOutButton.isHidden = true
        logInView.contentView.isHidden = false
        
    }
    
    private func configureLogOutButton()
    {
        logOutButton.setTitle("Log Out", for: .normal)
        logOutButton.setTitleColor(.red, for: .normal)
        logOutButton.isHidden = true
        logOutButton.addTarget(self, action: #selector(IntroScreenUIController.logOut(_:)), for: .touchUpInside)
    }
    
    @objc func logOut(_ sender: UIButton! )
    {
        self.controller.requestLogOut()
    }
    
    private func configureLogInView()
    {
        logInView.setLogInMethod() { [unowned self] (email,password) in
            //self.controller.requestLogIn(email: email,password: password)
            self.controller.requestLogIn(email: "test@test.coms",password: "test123")

        }
    }
    
}
