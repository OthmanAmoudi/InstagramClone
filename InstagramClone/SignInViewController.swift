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
        
        emailTextField.text="red@fan.com"
        passwordTextField.text="123456"
        
        handleTextFields()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FIRAuth.auth()?.currentUser != nil{
            self.performSegue(withIdentifier: "ToHomeTabBarSegue", sender: nil)
        }
    }
    
    
    @IBAction func signInBtn_didClick(_ sender: Any) {
        ProgressHUD.show("Logging in ...", interaction: false)
        
        view.endEditing(true)
        
        AuthServices.signIn(email: emailTextField.text!, password: passwordTextField.text!, onSuccess: {
            ProgressHUD.showSuccess("sucessful")
            self.performSegue(withIdentifier: "ToHomeTabBarSegue", sender: nil)
        }, onError: { error in
            ProgressHUD.dismiss()
            print(error!)
            
            let alert = UIAlertController(title: "Error", message: "\(error!)", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
            
            return
            
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
