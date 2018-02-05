//
//  ConnectionView.swift
//  BridgeBuilder
//
//  Created by Ryan Bergamini on 12/27/17.
//  Copyright © 2017 Underdog Technologies. All rights reserved.
//

import Foundation
import UIKit

let colors: [UIColor] = [.red, .blue, .yellow, .orange, .green]

class ConnectionView : UIView
{
    private let connection: Connection!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var displayLabel: UILabel!
    
    init(frame: CGRect,connection: Connection)
    {
        self.connection = connection
        super.init(frame: frame)
        Bundle.main.loadNibNamed("ConnectionView",owner:self,options: nil)
        addSubview(contentView)
        //contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        configureView()
    }
    
    func configureView()
    {
        contentView.backgroundColor = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        displayLabel.text = "\(connection.profile.firstName)"
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
