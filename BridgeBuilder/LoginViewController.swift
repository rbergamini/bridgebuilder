//
//  LoginViewController.swift
//  BridgeBuilder
//
//  Created by Ryan Bergamini on 6/11/17.
//  Copyright © 2017 Duke Innovation CoLab. All rights reserved.
//

import Foundation

import UIKit

import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var responseLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        
        if let user = Auth.auth().currentUser
        {
            self.responseLabel.text = "Signed in as " + user.email!;
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logIn(_ sender: Any)
    {
        if let email:String = emailTextField.text, let password:String = passwordTextField.text
        {
            Auth.auth().signIn(withEmail:email,password:password)
            {
                (user, error) in
                if let error = error
                {
                    self.handleError(error)
                }
                
                if let user = user
                {
                    self.responseLabel.text = "Signed in as " + user.email!;
                }
            }
        }
    }

    @IBAction func logOut(_ sender: Any)
    {
        try! Auth.auth().signOut();
        
        responseLabel.text = "Sign in or create an account!"
    }
    
    @IBAction func createAccount(_ sender: Any)
    {
        if let email:String = emailTextField.text, let password:String = passwordTextField.text
        {
        
            Auth.auth().createUser(withEmail:email,password:password)
            {[unowned self](user, error) in
                if let error = error
                {
                    self.handleError(error);
                }
                
                if let user = user
                {
                    self.responseLabel.text = "Signed in as " + user.email!;
                    
                    self.performSegue(withIdentifier: "createProfile", sender: nil)
                }
                
            }
           
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let ref:String = segue.identifier
        {
            //print(ref)
            if ref == "createProfile"
            {
               let destinationVC = segue.destination as! EditProfileViewController
                if let currentUser = Auth.auth().currentUser
                {
                    destinationVC.userID = currentUser.uid
                }
            }
        }
    }
    // TODO: Define the correct class for the FIR Auth Error
    func handleError(_ error: Error)
    {
        /*
        if let error = error
        {
            let errorCode = AuthErrorCode(rawValue: error.code);
            if (errorCode == .ErrorCode)
        } */
            
        responseLabel.text = error.localizedDescription;
    }
    
    
    

    
}

