//
//  HomeScreenUIController.swift
//  BridgeBuilder
//
//  Created by Ryan Bergamini on 12/27/17.
//  Copyright © 2017 Underdog Technologies. All rights reserved.
//

import Foundation
import UIKit

class HomeScreenUIController : HomeScreenDelegate
{
    private var view: UIView!
    private var connectionContainerView: ConnectionContainerView!
    private var subViewCount: Int = 0
    private weak var navigator: HomeScreenNavigatorProtocol!
    
    init(view: UIView, navigator: HomeScreenNavigatorProtocol)
    {
        self.view = view
        self.connectionContainerView = ConnectionContainerView(frame:self.view.frame)
        self.navigator = navigator
        view.addSubview(connectionContainerView)
        
        let button: UIButton = createButton()
        view.addSubview(button)
        view.bringSubview(toFront: button)
        
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.bottomAnchor.constraint(equalTo: connectionContainerView.bottomAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: connectionContainerView.centerXAnchor).isActive = true

        /*
        self.stackView = UIStackView(frame: CGRect(x:0,y:0,width:40,height: view.bounds.size.height))
        stackView.axis = .vertical
        stackView.alignment = .leading
        //stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stackView.spacing = 120
        view.addSubview(stackView)*/
    }
 
    func createButton() -> UIButton
    {
        let button: UIButton = UIButton(frame: CGRect(x: 5, y: 50, width: 40, height: 30))
        button.backgroundColor = UIColor.red
        button.setTitle("Add", for: .normal)
        button.addTarget(self, action: #selector(HomeScreenUIController.createConnection(_:)), for: .touchUpInside)
        return button
    }
    
    @objc func createConnection(_ sender: UIButton!)
    {
        print("creating new connection")
        navigator.goToAddScreen()
    }
    
    func displayConnection(_ connection: Connection)
    {
        print(connection.description)
        connectionContainerView.addConnection(connection)
        /*
        let connectionView = ConnectionView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), connection: connection)
        connectionView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        connectionView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        stackView.addArrangedSubview(connectionView)
        subViewCount += 1
        print(subViewCount)
        for v in stackView.arrangedSubviews
        {
            print(v)
        }*/
    }
   
}
