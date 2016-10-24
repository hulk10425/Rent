//
//  ChatViewCell.swift
//  Renter
//
//  Created by apple on 2016/10/11.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import Kingfisher

class ChatViewCell: UITableViewCell{
    //要將兩個cell里的image和label都拉在同一個關聯裡
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var messageView: UIView!

    @IBOutlet weak var dateLabel: UILabel!
 
    var bubbleWidthAnchor: NSLayoutConstraint?
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var triangle: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     messageView.layer.cornerRadius = 10
    profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
     profileImageView.clipsToBounds = true
    }
    func configCell(idUser: String, message: Dictionary<String, AnyObject>) {
   
        
        self.messageTextView.text = message["message"] as? String
        if let seconds = message["date"]!.doubleValue {
            let timestampDate = NSDate(timeIntervalSince1970: seconds)
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM月dd日,hh:mm a"
           self.dateLabel.text = dateFormatter.stringFromDate(timestampDate)
        }
        
        
//        self.dateLabel.text  = message["date"] as? String
        
       
        DataService.dataService.PEOPLE_REF.child(idUser).observeEventType(.Value, withBlock: {(snapshot) in
            let dict = snapshot.value as! Dictionary<String, AnyObject>
            let imageUrl = dict["profileImage"] as! String
            if imageUrl.hasPrefix("gs://"){
                 self.profileImageView.kf_setImageWithURL(NSURL(string: imageUrl))
            FIRStorage.storage().referenceForURL(imageUrl).dataWithMaxSize(INT64_MAX, completion: { (data, error) in
                if let error = error{
                print(error)
                    return
                }
                self.profileImageView.image = UIImage.init(data: data!)
            })
            }
        
    })

    }
}