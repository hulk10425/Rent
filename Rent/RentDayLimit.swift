//
//  RentDayLimit.swift
//  Renter
//
//  Created by apple on 2016/10/3.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit
import FirebaseAnalytics
import ActionSheetPicker_3_0

class RentDayLimit: UITableViewCell, UITextFieldDelegate {
     var myUserDefaluts: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    @IBOutlet weak var rentDayField: UITextField!
    
    @IBOutlet weak var rentDayButton: UIButton!
    @IBOutlet weak var rentDayLabel: UILabel!

    override func awakeFromNib() {
        rentDayLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        rentDayLabel.numberOfLines = 0
        rentDayLabel.text = "最短\n租期"
        rentDayField.delegate = self
        rentDayButton.addTarget(self, action: #selector(selectClicked(_:)), forControlEvents: .TouchDown)

    }
    func selectClicked(sender: UIButton){
        
        let acp = ActionSheetStringPicker(title: "最短租期", rows: ["三個月","半年","一年"]
            , initialSelection: 0, doneBlock: {
                picker, value, index in
                self.rentDayField.text = String(index)
            
                self.myUserDefaluts.setObject("\(index)", forKey: "rentDayLimit")
               
                   FIRAnalytics.logEventWithName("press_rentDayLimit", parameters: ["rentDayLimit_value": self.rentDayField.text!])
                
                return
            }, cancelBlock: { ActionMultipleStringCancelBlock in return }, origin: sender.superview)
        
        
        acp.showActionSheetPicker()
    }
    

    
    
    
    
    
    
    
    
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return false
    }
    //不讓使用者透過建盤輸入文字
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return false
    }


}
