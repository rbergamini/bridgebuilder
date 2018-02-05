//
//  GameUIController.swift
//  BridgeBuilder
//
//  Created by Ryan Bergamini on 1/7/18.
//  Copyright © 2018 Underdog Technologies. All rights reserved.
//

import Foundation
import UIKit

class GameViewController
{
    private var view: UIView!
    private weak var gameControl: GameControlProtocol?
    
    init(view: UIView, controller: GameControlProtocol?)
    {
        self.view = view
        self.gameControl = controller
    }
}
