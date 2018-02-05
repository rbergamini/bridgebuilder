//
//  ConnectionViewController.swift
//  
//
//  Created by Ryan Bergamini on 7/2/17.
//
//

import Foundation

import UIKit

import Firebase

class ConnectionViewController : UIViewController
{
    var connectionID: String = "No Connection"
    
    @IBOutlet weak var output: UILabel!
    
    override func viewDidLoad()
    {
        output.text = connectionID
        
        super.viewDidLoad()
    }
    
    func updateView()
    {
        output.text = connectionID
    }
    
}
