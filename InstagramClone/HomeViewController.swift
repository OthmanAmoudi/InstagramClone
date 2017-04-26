//
//  HomeViewController.swift
//  InstagramClone
//
//  Created by Othman Mashaab on 19/04/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit
import FirebaseAuth
class HomeViewController: UIViewController {

    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
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
