//
//  LogInView.swift
//  BridgeBuilder
//
//  Created by Ryan Bergamini on 12/18/17.
//  Copyright © 2017 Underdog Technologies. All rights reserved.
//
// Guidlines from https://medium.com/@brianclouser/swift-3-creating-a-custom-view-from-a-xib-ecdfe5b3a960

// #SketchPractice how to set up initializers, setter function for logInMethod

import Foundation
import UIKit

class LogInView : UIView
{
   
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var emailTextBox: UITextField!
    @IBOutlet weak var passwordTextBox: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    private var logInMethod: (String,String) -> () = { (email,password) in print("\(email) \(password)")}
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        commonInit()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setLogInMethod(_ logInMethod: @escaping (String,String) -> ())
    {
        self.logInMethod = logInMethod
        
    }
    
    private func commonInit()
    {
        Bundle.main.loadNibNamed("LogInView",owner:self,options: nil)
        addSubview(contentView)
        
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    @IBAction func triggerLogInMethod(_ sender: Any)
    {
        var eText: String = ""
        var pText: String = ""
        if let emailText: String = emailTextBox.text
        {
            eText = emailText
        }
        if let passwordText: String = passwordTextBox.text
        {
            pText = passwordText
        }
        
        logInMethod(eText,pText)
    }
}

/*
 private let emailTextBox: UITextField
 private let passwordTextBox: UITextField
 private let logInButton: UIButton
 private let logInMethod: (String,String) -> ()
 
 init(frame: CGRect, logInMethod: @escaping (String,String)->())
 {
 let width = frame.size.width
 let height = frame.size.height
 let textHeight = 0.3*height;
 let buffer: CGFloat = 5;
 
 self.emailTextBox = UITextField(frame: CGRect(x: 0, y: 0, width: width, height: textHeight))
 self.passwordTextBox = UITextField(frame: CGRect(x: 0, y: emailTextBox.frame.size.height + buffer, width: width, height: textHeight))
 self.logInButton = UIButton(frame: CGRect(x: 0, y: passwordTextBox.anchor + passwordTextBox.height + buffer, width: width, height: textHeight))
 self.logInMethod = logInMethod
 
 super.init(frame: frame)
 }
 
 @available(*, unavailable)
 required init?(coder aDecoder: NSCoder) {
 fatalError("init(coder:) has not been implemented")
 }
 
 override func layoutSubviews()
 {
 super.layoutSubviews()
 
 
 }
 
 */
