//
//  ProfileViewController.swift
//  BridgeBuilder
//
//  Created by Ryan Bergamini on 6/11/17.
//  Copyright © 2017 Duke Innovation CoLab. All rights reserved.
//

import Foundation

import UIKit

import Firebase

class EditProfileViewController: UIViewController, UIAlertViewDelegate
{
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var middleInitialTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var question1TextField: UITextField!
    @IBOutlet weak var question2TextField: UITextField!
    @IBOutlet weak var question3TextField: UITextField!
    
    
    // TODO: Instantiate some actual error checking
    @IBOutlet weak var errorLabel: UILabel!
    
    var userID:String = "";
    
    
    let rootRef = Database.database();
    
    /*
     This method should check if all the fields have been filled out properly, save that info in Firebase, the segway to the home screen
    */
    @IBAction func submitInfoAndSegue(_ sender: Any)
    {
        // Load profile data into firebase
        
            if(allFieldsValid())
            {
                
                guard let firstName = readTextField(firstNameTextField) else
                {
                    errorLabel.text = "Invalid First Name"
                    showError(message:"Errrrrrror")
                    return
                }
                
                guard let middleInitial = readTextField(middleInitialTextField) else
                {
                    errorLabel.text = "Invalid Middle Initial"
                    return
                }
                
                guard let lastName = readTextField(lastNameTextField) else
                {
                    errorLabel.text = "Invalid Last Name"
                    return
                }
                
                guard let answer1 = readTextField(question1TextField) else
                {
                    errorLabel.text = "Invalid Answer 1"
                    return
                }
                
                guard let answer2 = readTextField(question2TextField) else
                {
                    errorLabel.text = "Invalid Answer 2"
                    return
                }
                
                guard let answer3 = readTextField(question3TextField) else
                {
                    errorLabel.text = "Invalid Answer 3"
                    return
                }
                
                updateDatabase(firstName,middleInitial,lastName,answer1,answer2,answer3);
                
                    
                performSegue(withIdentifier:"editProfileToMainScreen",sender:nil);
            }

    }
    
    private func readTextField(_ textField:UITextField) -> String?
    {
        if let text = textField.text
        {
            if text != ""
            {
                return text
            }
        }
        return nil
    }
    
    func showError(message: String)
    {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert);
        
        let defaultAction = UIAlertAction(title:"Close Alert", style: .default, handler: nil)
        
        alertController.addAction(defaultAction);
        
        present(alertController, animated: true, completion:nil);
        
    }
    func updateDatabase(_ firstName:String,_ middleInitial:String,_ lastName:String, _ answer1:String, _ answer2:String, _ answer3: String)
    {
        let ref = Database.database().reference().child("users").child(userID);
        ref.child("firstName").setValue(firstName);
        ref.child("middleInitial").setValue(middleInitial);
        ref.child("lastName").setValue(lastName);
        ref.child("answer1").setValue(answer1);
        ref.child("answer2").setValue(answer2);
        ref.child("answer3").setValue(answer3);
    }
  
    
    func allFieldsValid() -> Bool
    {
        
        return true
    }
}
