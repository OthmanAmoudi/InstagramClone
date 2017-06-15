//
//  Users.swift
//  InstagramClone
//
//  Created by Othman Mashaab on 07/06/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import Foundation
class Users{
    var userId: String
    var userName: String
    var userEmail: String
    var userProfilePic: String
    
    init(userIdString:String,userNameString:String,userEmailString:String,userProfilePicString:String) {
        userId = userIdString
        userName = userNameString
        userEmail = userEmailString
        userProfilePic = userProfilePicString
    }
}
