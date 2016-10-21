//
//  UserMessageCell.swift
//  Renter
//
//  Created by apple on 2016/10/15.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit
import Firebase

class UserMessageCell: UITableViewCell {
    
    @IBOutlet weak var userMessageImage: UIImageView!

    @IBOutlet weak var userMessageLabel: UILabel!

    @IBOutlet weak var userMessageNameLabel: UILabel!

    @IBOutlet weak var userMessageTimeLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userMessageImage.layer.cornerRadius = userMessageImage.frame.size.height / 2

        userMessageImage.clipsToBounds = true
        
    }

//    func configCell(idUser: String, users: Dictionary<String, AnyObject>) {
//              //self.userMessageTimeLabel.text  = users["date"] as? String
//        
//        
//        
//    }
//
//


}
