//
//  AuthServices.swift
//  InstagramClone
//
//  Created by Othman Mashaab on 25/04/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import Firebase
import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AuthServices {
    
    static func signIn(email: String, password: String, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: {(user,error) in
            if error != nil{
                onError(error!.localizedDescription)
                return
            }
            onSuccess()
        })
    }
    
    
    static func signUp(username: String ,email: String, password: String, imageData: Data, onSuccess: @escaping () -> Void, onError: @escaping (_ errorMessage: String?) -> Void) {
        FIRAuth.auth()?.createUser(withEmail: email,password: password, completion: {(user: FIRUser?, error: Error?)in
            if error != nil {
                onError(error?.localizedDescription)
                return

            }
            let uid = user?.uid
            let storageRef = FIRStorage.storage().reference(forURL: Config.STORAGE_ROOF_REF ).child("profile_image").child(uid!)
            
            
            storageRef.put(imageData, metadata: nil, completion: {(metadata, error) in
                
                if error != nil{
                    return
                }
                
                let profileImgUrl = metadata?.downloadURL()?.absoluteString
                
                
                self.setUserInformation(profileImgUrl: profileImgUrl!, username: username, email: email, uid: uid!, onSuccess: onSuccess)
            })
            
        })
    }
    
    static func setUserInformation(profileImgUrl: String, username: String, email: String, uid: String, onSuccess: @escaping () -> Void){
        let ref = FIRDatabase.database().reference()
        let userReference = ref.child("users")
        let newUserReference = userReference.child(uid)
        newUserReference.setValue(["username": username, "email": email, "Profile Picture":profileImgUrl])
        onSuccess()
        
    }
}
