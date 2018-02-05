//
//  HomeScreenViewController.swift
//  BridgeBuilder
//
//  Created by Ryan Bergamini on 12/27/17.
//  Copyright © 2017 Underdog Technologies. All rights reserved.
//

import Foundation
import UIKit

protocol HomeScreenNavigatorProtocol : class
{
    func goToAddScreen()
}

class HomeScreenViewController : UIViewController, HomeScreenNavigatorProtocol
{
    private var homeScreenDelegate: HomeScreenDelegate?
    private var homeScreenHandler: HomeScreenHandler?
    
    init()
    {
        self.homeScreenHandler = HomeScreenController()
        super.init(nibName: nil, bundle: nil)
        self.homeScreenDelegate = HomeScreenUIController(view: view, navigator: self)
        homeScreenHandler?.delegate = homeScreenDelegate
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print("Home Screen has been loaded")
    }
    
    func goToAddScreen()
    {
        let newConnectionController = NewConnectionViewController()
        self.present(newConnectionController, animated: false, completion: nil)
    }
}
