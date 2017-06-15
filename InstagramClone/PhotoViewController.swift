//
//  PhotoViewController.swift
//  InstagramClone
//
//  Created by Othman Mashaab on 19/04/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
class PhotoViewController: UIViewController {

    @IBOutlet weak var clear: UIBarButtonItem!
    @IBOutlet weak var postPhotoContainer: UIImageView!
    @IBOutlet weak var textCaption: UITextView!
    @IBOutlet weak var shareBtn: UIButton!
    
    var postSelected: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textCaption.text="Enter caption here"
        let tap = UITapGestureRecognizer(target: self, action: #selector(PhotoViewController.handleImagePosted) )
        postPhotoContainer?.addGestureRecognizer(tap)
        postPhotoContainer?.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handlePost()

    }
   
    @IBAction func share_DidPressed(_ sender: Any) {
        ProgressHUD.show("Waiting...", interaction: false)
        if let userPhotoimg =  self.postSelected, let imageData = UIImageJPEGRepresentation(userPhotoimg, 0.1){
            let postId = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference(forURL: Config.STORAGE_ROOF_REF ).child("posts").child(postId)
            storageRef.put(imageData, metadata: nil, completion: {(metadata, error) in
                
                if error != nil{
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
                
                let postUrl = metadata?.downloadURL()?.absoluteString
                self.sendDataToDatabase(postUrl: postUrl!)
              
            })
            
                    } else{
            ProgressHUD.showError("Please select a Photo")
            print("Photos cant be empty")
        }

    }
    
    func sendDataToDatabase(postUrl:String){
     //   let userid =
        let ref = FIRDatabase.database().reference()
        let postReference = ref.child("posts")
        let newPostId = postReference.childByAutoId().key
        let newPostReference = postReference.child(newPostId)
        //let user : FIRUser?
        //guard let validUserID = user?.uid else { return }
        let userID: String = FIRAuth.auth()!.currentUser!.uid
      //  self.dbRef.child("users").updateChildValues([validUserID:userDictionary])
     /*   if FIRAuth().currentUser != nil {
            // User is signed in.
            // ...
        } else {
            // No user is signed in.
            // ...
        }
       */
        newPostReference.setValue(["photoURL": postUrl,"caption":textCaption.text!,"userId": userID,"postId": newPostId], withCompletionBlock: {
            (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
            }
            else{
                ProgressHUD.showSuccess("Success")
                self.clean()
                self.tabBarController?.selectedIndex=0
            }
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleImagePosted(){
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func clearBtn(_ sender: Any) {
      
        clean()
        handlePost()
    }
    
    func clean(){
        postPhotoContainer.image = UIImage(named: "gallery-icon")
        self.postSelected = nil
        textCaption.text = "Enter Caption here"
    }

    func handlePost(){
        if postSelected == nil{
            shareBtn.isEnabled = false
            clear.isEnabled = false
            shareBtn.backgroundColor = .lightGray
        }
        else{
            shareBtn.isEnabled = true
            clear.isEnabled=true
            shareBtn.backgroundColor = .black
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}

extension PhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        print("did finish picking")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            postPhotoContainer.image = image
            postSelected = image
            
        }
        
        print(info)
        //  profilePictureContainer.image = infoPhoto
        dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
        
    }
    
}
