//
//  HousePictureCell.swift
//  Renter
//
//  Created by apple on 2016/9/30.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit
import DKImagePickerController
import Firebase


class HousePictureCell: UITableViewCell {

    
    @IBOutlet weak var houseImageButton: UIButton!

    @IBOutlet weak var houseImage: UIImageView!
    
   override func awakeFromNib() {
    super.awakeFromNib()
  
  
    }
    
//    func configCell(post: PostData){
//    
//        if  let imageUrl = post.imageUrl{
//            if imageUrl.hasPrefix("gs://"){
//                FIRStorage.storage().referenceForURL(imageUrl).dataWithMaxSize(INT64_MAX, completion: { (data, error) in
//                    if let error = error{
//                    print("Error downloading\(error)")
//                    return
//                    }
//                    self.houseMultipleImage.image = UIImage.init(data: data!)
//                    
//                })
//            
//            }else if let url = NSURL(string: imageUrl), data = NSData(contentsOfURL: url){
//            
//            self.houseMultipleImage.image = UIImage.init(data: data)
//            }
//        }
//        
//        
//    }
    
}
