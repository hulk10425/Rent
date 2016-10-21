//
//  RentMoneyAdditionCell.swift
//  Renter
//
//  Created by apple on 2016/10/3.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit

class RentMoneyAdditionCell: UITableViewCell {

    @IBOutlet weak var rentMoneyAdditionButton: UIButton!
    

    @IBOutlet weak var selectAdditionalCostLabel: UILabel!
    @IBOutlet weak var rentMoneyAdditionLabel: UILabel!
    override func awakeFromNib() {
         rentMoneyAdditionLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
         rentMoneyAdditionLabel.numberOfLines = 0
         rentMoneyAdditionLabel.text = "租金\n包含"
    }
    
}
