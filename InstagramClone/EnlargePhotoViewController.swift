//
//  EnlargePhotoViewController.swift
//  InstagramClone
//
//  Created by Othman Mashaab on 16/06/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit

class EnlargePhotoViewController: UIViewController {

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var enlargedPhoto: UIImageView!
    
    var labelText = String()
    var myImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       myLabel.text = labelText
        enlargedPhoto.image = myImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
