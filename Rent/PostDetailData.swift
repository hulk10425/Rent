//
//  PostDetailData.swift
//  Renter
//
//  Created by apple on 2016/10/6.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit
import Firebase

class PostDetailData: UITableViewController{

    @IBOutlet var myTableView: UITableView!
    
    
    @IBOutlet weak var getTitle: UILabel!
    
    @IBOutlet weak var getRegion: UILabel!
    
    @IBOutlet weak var getImage: UIImageView!
    
    @IBOutlet weak var getRentMoney: UILabel!
    
    @IBOutlet weak var getAdditionalCost: UILabel!
    
    @IBOutlet weak var getDeposit: UILabel!
    
    
    @IBOutlet weak var getRentDay: UILabel!
    
    @IBOutlet weak var getType: UILabel!
    
    @IBOutlet weak var getPerson: UILabel!
    
    @IBOutlet weak var getFurniture: UILabel!
    
    
    @IBOutlet weak var getNote: UILabel!
    
    var detailInfo: PostData!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title  = "詳細資訊"
        print(detailInfo)
   
        getTitle.text = detailInfo.title
        getRentMoney.text = detailInfo.rentMoney
        getAdditionalCost.text = detailInfo.additionalCost
        getDeposit.text = detailInfo.deposit
        getRentDay.text = detailInfo.rentDay
        getType.text = detailInfo.type
        getPerson.text = detailInfo.person
        getFurniture.text = detailInfo.furniture
        getNote.text = detailInfo.note
        
        
        let imageUrl = detailInfo.imageUrl
        if imageUrl.hasPrefix("gs://"){
            self.getImage.kf_setImageWithURL(NSURL(string: imageUrl))
            FIRStorage.storage().referenceForURL(imageUrl).dataWithMaxSize(INT64_MAX, completion: { (data, error) in
                if let error = error{
                    print(error)
                    return
                }
                self.getImage.image = UIImage.init(data: data!)
            })
        }

        
        
        
        
        
        
    
    }
    

    
    
    

}

