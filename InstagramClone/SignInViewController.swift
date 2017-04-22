//
//  SignInViewController.swift
//  InstagramClone
//
//  Created by Othman Mashaab on 22/04/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        signInBtn.isEnabled=false
        handleTextFields()
    }


    @IBAction func signInBtn_didClick(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(user, error) in
            if error != nil{
                print(error!.localizedDescription)
                return
            }
            self.performSegue(withIdentifier: "ToHomeTabBarSegue", sender: nil)
        })
        
    }
 
override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}


func handleTextFields(){
    passwordTextField?.addTarget(self, action: #selector(SignInViewController.handleTextFieldDidChanged), for: UIControlEvents.editingChanged)
    emailTextField?.addTarget(self, action: #selector(SignInViewController.handleTextFieldDidChanged), for: UIControlEvents.editingChanged)
}

func handleTextFieldDidChanged(){
    guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
        signInBtn.setTitleColor(UIColor.red, for: UIControlState.normal)
        signInBtn.isEnabled=false
        return
    }
    
    signInBtn.setTitleColor( .green , for: UIControlState.normal)
    signInBtn.isEnabled=true
}


}
