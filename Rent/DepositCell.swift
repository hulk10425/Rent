//
//  DepositCell.swift
//  Renter
//
//  Created by apple on 2016/9/30.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import FirebaseAnalytics

class DepositCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var depositField: UITextField!
    
    @IBOutlet weak var depositButton: UIButton!
    override func awakeFromNib() {
        depositField.delegate = self
        depositButton.addTarget(self, action: #selector(selectClicked(_:)), forControlEvents: .TouchDown)
        
    }
    func selectClicked(sender: UIButton){
        
        
        let acp = ActionSheetStringPicker(title: "押金選擇", rows: ["一個月","兩個月"]
            , initialSelection: 0, doneBlock: {
                picker, value, index in
                self.depositField.text = String(index)
                
                FIRAnalytics.logEventWithName("press_deposit", parameters: ["deposit_value": self.depositField.text!])
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
