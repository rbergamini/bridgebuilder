//
//  ConnectionContainerView.swift
//  BridgeBuilder
//
//  Created by Ryan Bergamini on 1/2/18.
//  Copyright © 2018 Underdog Technologies. All rights reserved.
//

import Foundation
import UIKit

class ConnectionContainerView : UIView
{
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    override init(frame: CGRect)
    {
        /*
        self.connection = connection
        super.init(frame: frame)
        Bundle.main.loadNibNamed("ConnectionView",owner:self,options: nil)
        addSubview(contentView)
        //contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        configureView()*/
        
        super.init(frame: frame)
    Bundle.main.loadNibNamed("ConnectionContainerView",owner:self,options: nil)
        addSubview(contentView)
        configureView()
    }
    
    func configureView()
    {
        
    }
    
    func addConnection(_ connection: Connection)
    {
        let connectionView = ConnectionView(frame: CGRect(x: 0, y: 0, width: 10, height: 10), connection: connection)
        stackView.addArrangedSubview(connectionView)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
