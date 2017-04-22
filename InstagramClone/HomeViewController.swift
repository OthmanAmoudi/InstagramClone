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
        print(FIRAuth.auth()?.currentUser as Any)
        do{
        try FIRAuth.auth()?.signOut()
        } catch let logoutError{
            print(logoutError)
        }
        print(FIRAuth.auth()?.currentUser as Any)
        dismiss(animated: true, completion: nil)
    }
    


}
