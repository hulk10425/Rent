//
//  ShowPostDataCell.swift
//  Renter
//
//  Created by apple on 2016/10/6.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class ShowPostDataCell: UITableViewCell{

    @IBOutlet weak var postImage: UIImageView!

    @IBOutlet weak var postTitleText: UILabel!

    @IBOutlet weak var postRegionText: UILabel!

    @IBOutlet weak var postPersonsText: UILabel!

    @IBOutlet weak var postType: UILabel!
    @IBOutlet weak var postRentMoneyText: UILabel!

    @IBOutlet weak var toChatButton: UIButton!
    
    
    
    override func awakeFromNib() {
        toChatButton.layer.cornerRadius = 10
        postImage.layer.cornerRadius = 8
        postImage.clipsToBounds = true
    }
    func configureCell(post: PostData){
    self.postTitleText.text = post.title
        self.postType.text = post.type
        self.postPersonsText.text = post.person
        self.postRentMoneyText.text = String(post.rentMoney)
        
     
        
        
        
        if let imageUrl = post.imageUrl{
            if imageUrl.hasPrefix("gs://"){
                self.postImage.kf_setImageWithURL(NSURL(string: imageUrl), placeholderImage: UIImage(named: "house-outline"))
              dispatch_async(dispatch_get_global_queue( QOS_CLASS_DEFAULT , 0 )) {
            FIRStorage.storage().referenceForURL(imageUrl).dataWithMaxSize(INT64_MAX, completion: { (data, error) in
                
        
                if let error = error {
                print("Error downloading\(error)")
                    return
                }
             dispatch_async(dispatch_get_main_queue(), {
              self.postImage.image = UIImage.init(data: data!)
                })
            })
            }
            }else if let url = NSURL(string: imageUrl), data = NSData(contentsOfURL: url){
           
            self.postImage.image = UIImage.init(data: data)
            }
    
       
        }
        

    }
 
}