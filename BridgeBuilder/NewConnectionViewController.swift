//
//  NewConnectionViewController.swift
//  BridgeBuilder
//
//  Created by Ryan Bergamini on 1/7/18.
//  Copyright © 2018 Underdog Technologies. All rights reserved.
//

import Foundation
import UIKit

protocol NewConnectionControlProtocol : class
{
    func playGameWithNewUser()
    func playGameWithOldUser()
}

class NewConnectionViewController : UIViewController, NewConnectionControlProtocol
{
    private let newConnectionHandler: NewConnectionHandler!
    private var newConnectionController: NewConnectionDelegate!
    
    
    init()
    {
        self.newConnectionHandler = NewConnectionController()
        super.init(nibName: nil, bundle: nil)
        newConnectionController = NewConnectionUIController(view: view, control: self)
        newConnectionHandler.delegate = newConnectionController
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func playGameWithNewUser()
    {
        let connection = newConnectionHandler.retrieveConnectionWithNewUser()
        print(connection)
    }
    
    func playGameWithOldUser()
    {
        newConnectionHandler.retrieveConnectionWithOldUser() { (connection) in
            print("Got Connection With: \(connection.profile.description)")
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
}
