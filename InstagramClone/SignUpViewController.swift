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
      
        profilePictureContainer?.layer.cornerRadius = 50
       // profilePictureContainer?.layer.masksToBounds = true
        profilePictureContainer?.clipsToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handleImageChosen) )
        profilePictureContainer?.addGestureRecognizer(tap)
        profilePictureContainer?.isUserInteractionEnabled = true
        signUpBtn?.isEnabled=false
        handleTextFields()

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
        FIRAuth.auth()?.createUser(withEmail: emailTextField.text!,password: passwordTextField.text!, completion: {(user: FIRUser?, error: Error?)in
            if error != nil {
                
                let alert = UIAlertController(title: "Error", message: "\(error!.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
                let cancelAction = UIAlertAction(title: "Try Again", style: UIAlertActionStyle.cancel, handler: nil)
                alert.addAction(cancelAction)
                print(error!.localizedDescription)
                self.present(alert, animated: true, completion: nil)
                return
            }
            let uid = user?.uid
            let storageRef = FIRStorage.storage().reference(forURL: "gs://instagramclone-e03f1.appspot.com/").child("profile_image").child(uid!)
            if let userPhotoimg =  self.selectedProfilePicture, let imageData = UIImageJPEGRepresentation(userPhotoimg, 0.1){
                storageRef.put(imageData, metadata: nil, completion: {(metadata, error) in
                 
                    if error != nil{
                        return
                    }
                    
                    let profileImgUrl = metadata?.downloadURL()?.absoluteString
                    let ref = FIRDatabase.database().reference()
                    let userReference = ref.child("users")
                    let newUserReference = userReference.child(uid!)
                    newUserReference.setValue(["username": self.usernameTextField.text!, "email": self.emailTextField.text!, "Profile Picture":profileImgUrl])
                    self.performSegue(withIdentifier: "SignUpToHomeTabBarSegue", sender: nil)
                })
            }
           
     
        })
        
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
