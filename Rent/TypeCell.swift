//
//  TypeCell.swift
//  Renter
//
//  Created by apple on 2016/9/29.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit
import FirebaseAnalytics
import ActionSheetPicker_3_0

class TypeCell: UITableViewCell, UITextFieldDelegate {
    var typeArray = ["獨立套房","分租套房","雅房","共生住宅","整層住家"]
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var typeButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        typeField.delegate = self
        typeButton.addTarget(self, action: #selector(selectClicked(_:)), forControlEvents: .TouchDown)
        
        
    }
    
    let order = Order()
    func selectClicked(sender: UIButton){
        
        let acp = ActionSheetStringPicker(title: "類型選擇", rows: self.typeArray
            , initialSelection: 0, doneBlock: {
                picker, value, index in
                self.typeField.text = String(index)
                
                self.order.type = self.typeField.text
                
                FIRAnalytics.logEventWithName("press_type", parameters: ["type_value": self.typeField.text!])
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
