//
//  HomeViewController.swift
//  InstagramClone
//
//  Created by Othman Mashaab on 19/04/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutBtn: UIBarButtonItem!

    var posts = [Posts]()
    var users = [Users]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.dataSource=self
        tableView.delegate=self
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "postCell")
        // Do any additional setup after loading the view.
        loadPosts()
        handlImages()
    }

    
    func loadPosts(){
        FIRDatabase.database().reference().child("posts").observe(.childAdded){ (snapshot:FIRDataSnapshot)in
          
        if let dictionary = snapshot.value as? [String: Any]{
          let mycaption =  dictionary["caption"] as! String
          let mypic = dictionary["photoURL"] as! String
          let userID = dictionary["userId"] as! String
            
            let post = Posts(textCaption: mycaption, photoUrlString: mypic, userIdString: userID)
            
            FIRDatabase.database().reference().child("users").observe(.value, with: { (snapshot) in
                
                var users = snapshot.value as! [String:AnyObject]
                //  let myusers = snapshot.childSnapshot(forPath: userID) as? [String:AnyObject]
                for(_,value) in users  {
                    if let user = users.popFirst()?.key as? String{
                        if user == userID{
                            
                            let name = value["username"] as? String
                            let profilepic = value["Profile Picture"] as? String
                            let useremail = value["email"] as? String
                            let myusers = Users(userIdString: userID, userNameString: name!, userEmailString: useremail!, userProfilePicString: profilepic!)
                            
                            self.users.append(myusers)
                          //  self.tableView.reloadData()
                            self.posts.append(post)
                            self.tableView.reloadData()
                       //     print("|||||||||||||")
                        //    print(self.posts)
                         //   print("????????????")
                         //   print(self.users)
                        }
                    }
                }
            })

          
            }
        }


 
    
}
    
    func handlImages(){
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
      
        let imageView = UIImageView(frame: CGRect(x: 40, y: 40, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        let logo = UIImage(named: "Instagram_logo")
        imageView.image = logo
        navigationItem.titleView = imageView
    }

    @IBAction func logoutBtn_didClick(_ sender: Any) {
       let alert = UIAlertController(title: "Confirm", message: "are you sure you want to Log out ?", preferredStyle: UIAlertControllerStyle.actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        let logout = UIAlertAction(title: "Logout", style: UIAlertActionStyle.default) { (UIAlertAction) in
            print(FIRAuth.auth()?.currentUser as Any)
            do{
                ProgressHUD.show("logging out...", interaction: false)
                try FIRAuth.auth()?.signOut()
            } catch let logoutError{
                print(logoutError)
            }
            ProgressHUD.dismiss()
            print(FIRAuth.auth()?.currentUser as Any)
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancel)
        alert.addAction(logout)
        self.present(alert, animated: true, completion: nil)

    }
    
}
extension UIImageView {
    func downloadImage(from imgURL: String!) {
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

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell()
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! TableViewCell
        
        //cell.backgroundColor = UIColor.lightGray
        //cell.textLabel?.text = "\(indexPath.row + 1)"
        
         cell.captionLabel2?.text = posts[indexPath.row].caption
         cell.postContainer2.downloadImage(from: posts[indexPath.row].photoUrl)
      
        cell.nameLabel2?.text = users[indexPath.row].userName
        cell.ppContainer2?.downloadImage(from: users[indexPath.row].userProfilePic)
        return cell
    }
}
