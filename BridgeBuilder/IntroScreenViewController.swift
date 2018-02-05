//
//  IntroScreenViewController.swift
//  BridgeBuilder
//
//  Created by Ryan Bergamini on 12/12/17.
//  Copyright © 2017 Underdog Technologies. All rights reserved.
//

import Foundation

import UIKit



protocol IntroScreenFunctionalProtocol: class
{
    func requestLogIn(email: String, password: String)
    func requestLogOut()
    func requestHomeScreen()
}

class IntroScreenViewController : UIViewController, IntroScreenFunctionalProtocol
{
    private let introScreenHandler: IntroScreenHandler!
    private var introScreenUIController: IntroScreenDelegate!
    
    
    init()
    {
        self.introScreenHandler = IntroScreenController()
        super.init(nibName: nil, bundle: nil)
        introScreenUIController = IntroScreenUIController(view: view, controller: self)
        introScreenHandler.delegate = introScreenUIController
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
    
    }
    
    func requestLogIn(email: String, password: String)
    {
        self.introScreenHandler.logIn(withEmail: email,password: password)
    }
    
    func requestLogOut()
    {
        self.introScreenHandler.logOut()
    }
    
    func requestHomeScreen()
    {
        let homeViewController = HomeScreenViewController()
        self.present(homeViewController, animated: false, completion: nil)
    }
}
