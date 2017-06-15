//
//  ProfileViewController.swift
//  InstagramClone
//
//  Created by Othman Mashaab on 19/04/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    @IBOutlet weak var followingNum: UILabel!
    @IBOutlet weak var followersNum: UILabel!
    @IBOutlet weak var postsNum: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var MyCollectionView: UICollectionView!
    
    var currUser = [Users]()
    var currPosts = [Posts]()
    var currentUserPic = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MyCollectionView.delegate=self
        MyCollectionView.dataSource=self
        loadUserInfo()
        loadUserPosts()
    }
    
    func loadUserPosts(){
        var userID = FIRAuth.auth()!.currentUser!.uid
        FIRDatabase.database().reference().child("posts").observe(.value, with: { (snapshot) in
            let posts = snapshot.value as! [String:AnyObject]
            for(_,value) in posts {
                let caption = value["caption"] as? String
                
                let pictureURL = value["photoURL"] as! String
                
                let userId = value["userId"] as! String
                
                if userID == userId {
                    print("$$$$")
                    let currUserPic = Posts(textCaption: caption!, photoUrlString: pictureURL, userIdString: userId)
                    
                    self.currPosts.append(currUserPic)
                    self.MyCollectionView.reloadData()
                    print("###")
                    print(currUserPic)
                    print("@@@")
                    print(self.currPosts)
                    print("$$$")
                    print(userId)
                    print(pictureURL)
                    
                }
            }
        })
        
        
    }
    func loadUserInfo(){
        var userID = FIRAuth.auth()!.currentUser!.uid

        FIRDatabase.database().reference().child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            var users = snapshot.value as! [String:AnyObject]
            for(_,value) in users  {
                if let user = users.popFirst()?.key as? String{
                    if user == userID{
                        let name = value["username"] as! String
                        let profilepic = value["Profile Picture"] as! String
                        let useremail = value["email"] as? String
                        let myusers = Users(userIdString: userID, userNameString: name, userEmailString: useremail!, userProfilePicString: profilepic)
                        self.currUser.append(myusers)
                        self.navigationItem.title=name
                        self.profilePicture.downloadImage2(from: profilepic) 
//                        print("@@@")
//                        print(userID)
//                        print(name)
//                        print(profilepic)

                    }
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currPosts.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection_cell", for: indexPath) as! ProfileCollectionViewCell
        cell.imageCollection.downloadImage2(from: currPosts[indexPath.row].photoUrl)
        return cell
    }

}

extension UIImageView {
    func downloadImage2(from imgURL: String!) {
        let url = URLRequest(url: URL(string: imgURL)!)
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}
