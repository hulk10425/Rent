//
//  MyPostRoomsCell.swift
//  Rent
//
//  Created by apple on 2016/10/24.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class MyPostRoomsCell: UITableViewCell {

   
    @IBOutlet weak var MyPostRoomImage: UIImageView!
    
    @IBOutlet weak var MyPostRoomTitle: UILabel!
    
    @IBOutlet weak var MyPostRoomAddress: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        MyPostRoomImage.layer.cornerRadius = 8
        MyPostRoomImage.clipsToBounds = true
    }
    
    
    func configureCell(post: PostData){
      
        self.MyPostRoomTitle.text = post.title
      self.MyPostRoomAddress.text = post.region
        
        
        
        
        
        if let imageUrl = post.imageUrl{
            if imageUrl.hasPrefix("gs://"){
                self.MyPostRoomImage.kf_setImageWithURL(NSURL(string: imageUrl), placeholderImage: UIImage(named: "house-outline"))
                dispatch_async(dispatch_get_global_queue( QOS_CLASS_DEFAULT , 0 )) {
                    FIRStorage.storage().referenceForURL(imageUrl).dataWithMaxSize(INT64_MAX, completion: { (data, error) in
                        
                        
                        if let error = error {
                            print("Error downloading\(error)")
                            return
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            self.MyPostRoomImage.image = UIImage.init(data: data!)
                        })
                    })
                }
            }else if let url = NSURL(string: imageUrl), data = NSData(contentsOfURL: url){
                
                self.MyPostRoomImage.image = UIImage.init(data: data)
            }
            
            
        }
        
        
    }
    

    
    
    
    
//
//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//     
//    }

}
