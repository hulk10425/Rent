//
//  CustomHomePageButton.swift
//  Renter
//
//  Created by apple on 2016/9/28.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import Foundation
import UIKit
class CustomHomePageButton: UICollectionViewCell{

    @IBOutlet weak var homeImage: UIImageView!

   
    @IBOutlet weak var homeButton: UIButton!


    var title = ["我要找室友","共生住宅","一般租屋"]
    override func awakeFromNib() {
        homeButton.setTitle("我要找室友", forState: .Normal)
    }

}