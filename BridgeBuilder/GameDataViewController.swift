//
//  GameViewController.swift
//  BridgeBuilder
//
//  Created by Ryan Bergamini on 1/7/18.
//  Copyright © 2018 Underdog Technologies. All rights reserved.
//

import Foundation
import UIKit


protocol GameControlProtocol: class
{
    func addPoints(_ points: Int)
    func addConnectionToHistory(prompt:String,response:String,ofValue addedValue:Int)
    func addDifferenceToHistory(prompt:String,response:String,ofValue addedValue:Int)
    func getHistoricalMultiplier() -> Float
    func endGame()
}

class GameDataViewController : UIViewController, GameControlProtocol
{

    private var gameDataController: GameDataHandler!
    private var gameViewController: GameViewController!
    
    lazy private var scoreMultiplier: Float = {
        [unowned self] in
        return self.gameDataController.calculateHistoricalMultiplier()
    }()
    
    init(basedOn connection: Connection)
    {
        self.gameDataController = GameDataController(connection)
        super.init(nibName: nil, bundle: nil)
        self.gameViewController = GameViewController(view: self.view, controller: self)
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
    
    func addPoints(_ points: Int)
    {
        gameDataController.addPoints(points)
    }
    
    func addDifferenceToHistory( prompt:String, response:String, ofValue addedValue:Int)
    {
        addHistory(false,prompt,response,addedValue)
    }
    
    func addConnectionToHistory( prompt:String, response:String, ofValue addedValue:Int)
    {
        addHistory(true,prompt,response,addedValue)
    }
    
    func endGame()
    {
        // Send Connection To Database
        // Go Back To the Home Screen
    }
    
    func getHistoricalMultiplier() -> Float
    {
        return scoreMultiplier
    }
    
    private func addHistory(_ isConnection: Bool,_ prompt:String,_ response:String, _ addedValue:Int)
    {
        let connectionRecord: ConnectionRecord = ConnectionRecord(prompt: prompt, madeConnection: isConnection, response: response, value: addedValue)
        gameDataController.addHistory(connectionRecord)
    }

}
