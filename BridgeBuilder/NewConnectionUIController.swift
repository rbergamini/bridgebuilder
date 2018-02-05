//
//  NewConnectionUIController.swift
//  BridgeBuilder
//
//  Created by Ryan Bergamini on 1/7/18.
//  Copyright © 2018 Underdog Technologies. All rights reserved.
//

import Foundation
import UIKit

class NewConnectionUIController : NewConnectionDelegate
{
    
    private var view: UIView!
    private var emailText: UITextField!
    private var newNameText: UITextField!
    private weak var controller: NewConnectionControlProtocol!
    //private var usernameText: UITextField!
    
    private var playGameButton: UIButton!
    
    
    init(view: UIView, control: NewConnectionControlProtocol)
    {
        self.view = view
        self.controller = control
        self.emailText = UITextField(frame: CGRect(x: 10, y: 10, width: 300, height: 40))
        self.newNameText = UITextField(frame: CGRect(x: 10, y: 10, width: 300, height: 40))
        //self.usernameText = UITextField(frame: CGRect(x: 10, y: 10, width: 300, height: 40))
        
        self.playGameButton = createPlayButton()
        let playWithUserButton = createPlayWithUserButton()
        
        view.addSubview(playWithUserButton)
        view.addSubview(emailText)
        view.addSubview(newNameText)
        view.addSubview(playGameButton)
        //view.addSubview(usernameText)
        
        emailText.translatesAutoresizingMaskIntoConstraints = false
        newNameText.translatesAutoresizingMaskIntoConstraints = false
        playGameButton.translatesAutoresizingMaskIntoConstraints = false
        playWithUserButton.translatesAutoresizingMaskIntoConstraints = false
        
        emailText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        newNameText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playGameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playWithUserButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        emailText.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true;
        playWithUserButton.topAnchor.constraint(greaterThanOrEqualTo: emailText.bottomAnchor).isActive = true;
        newNameText.topAnchor.constraint(greaterThanOrEqualTo: playWithUserButton.bottomAnchor).isActive = true
        playGameButton.topAnchor.constraint(greaterThanOrEqualTo: newNameText.bottomAnchor).isActive = true
        
        emailText.placeholder = "Enter User Email"
        newNameText.placeholder = "Enter Name"
        //usernameText.placeholder = "Enter Username"
        
        emailText.backgroundColor = .white
        //usernameText.backgroundColor = .white
        newNameText.backgroundColor = .white
        
        configureView()
    }
    
    func getFirstName() -> String
    {
        if let name = newNameText.text
        {
            return name
        }
        return Profile.NOVALUE
    }
    
    func getEmail() -> String
    {
        if let email = emailText.text
        {
            return email
        }
        return Profile.NOVALUE
    }
    
    private func createPlayWithUserButton() -> UIButton
    {
        let button: UIButton = UIButton(frame: CGRect(x: 5, y: 50, width: 40, height: 30))
        button.backgroundColor = UIColor.green
        button.setTitle("Play", for: .normal)
        button.addTarget(self, action: #selector(NewConnectionUIController.playGameWithUser(_:)), for: .touchUpInside)
        return button
    }
    
    private func createPlayButton() -> UIButton
    {
        let button: UIButton = UIButton(frame: CGRect(x: 5, y: 50, width: 40, height: 30))
        button.backgroundColor = UIColor.green
        button.setTitle("Play", for: .normal)
        button.addTarget(self, action: #selector(NewConnectionUIController.playGame(_:)), for: .touchUpInside)
        return button
    }
    
    @objc func playGame(_ sender: UIButton!)
    {
        print("Playing Game")
        controller.playGameWithNewUser()
    }
    
    @objc func playGameWithUser(_ sender: UIButton!)
    {
        print("Playing Game with Existing User")
        controller.playGameWithOldUser()
    }
    
    func configureView()
    {
        
    }
}
