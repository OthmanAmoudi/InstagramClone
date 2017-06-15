//
//  SignInViewController.swift
//  InstagramClone
//
//  Created by Othman Mashaab on 19/04/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//
import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profilePictureContainer: UIImageView!
    
    var selectedProfilePicture: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        profilePictureContainer.layer.cornerRadius = profilePictureContainer.frame.size.width / 2
        profilePictureContainer.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handleImageChosen) )
        profilePictureContainer?.addGestureRecognizer(tap)
        profilePictureContainer?.isUserInteractionEnabled = true
        signUpBtn?.isEnabled=false
        handleTextFields()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func handleTextFields(){
        usernameTextField?.addTarget(self, action: #selector(SignUpViewController.handleTextFieldDidChanged), for: UIControlEvents.editingChanged)
        passwordTextField?.addTarget(self, action: #selector(SignUpViewController.handleTextFieldDidChanged), for: UIControlEvents.editingChanged)
        emailTextField?.addTarget(self, action: #selector(SignUpViewController.handleTextFieldDidChanged), for: UIControlEvents.editingChanged)
    }
    
    func handleTextFieldDidChanged(){
        guard let username = usernameTextField.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            signUpBtn.setTitleColor(UIColor.red, for: UIControlState.normal)
            signUpBtn.isEnabled=false
            return
        }
        
        signUpBtn.setTitleColor( .green , for: UIControlState.normal)
        signUpBtn.isEnabled=true
    }
    
    func handleImageChosen(){
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func signUpBtn_Touchupinside(_ sender: Any) {
        view.endEditing(true)
        ProgressHUD.show("Waiting...", interaction: false)
        if let userPhotoimg =  self.selectedProfilePicture, let imageData = UIImageJPEGRepresentation(userPhotoimg, 0.1){
            AuthServices.signUp(username: usernameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, imageData: imageData, onSuccess: {
                ProgressHUD.dismiss()
                self.performSegue(withIdentifier: "SignUpToHomeTabBarSegue", sender: nil)
                ProgressHUD.showSuccess("Account Created")
            }, onError: { (errorSring) in
                print(errorSring!)
                ProgressHUD.dismiss()
                let alert = UIAlertController(title: "Error", message: "\(errorSring!)", preferredStyle: UIAlertControllerStyle.alert)
                let cancelAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            })
        } else{
            ProgressHUD.showError("Please select a Photo")
            print("Photos cant be empty")
        }

    }
    
    @IBAction func dissmiss_OnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        print("did finish picking")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            profilePictureContainer.image = image
            selectedProfilePicture = image
        }
        print(info)
        //  profilePictureContainer.image = infoPhoto
        dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
        
    }
    
}
