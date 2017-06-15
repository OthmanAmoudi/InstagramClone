//
//  Posts.swift
//  InstagramClone
//
//  Created by Othman Mashaab on 06/06/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import Foundation
class Posts{
    
    var caption: String
    var photoUrl: String
    var userId: String
    init(textCaption: String,photoUrlString: String,userIdString: String) {
        caption = textCaption
        photoUrl = photoUrlString
        userId = userIdString
    }

}
