//
//  RentMoneyCell.swift
//  Renter
//
//  Created by apple on 2016/10/3.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit
import FirebaseAnalytics
class RentMoneyCell: UITableViewCell {
    @IBOutlet weak var rentMoneyTextField: UITextField!
    
    override func awakeFromNib() {
        rentMoneyTextField.delegate = self
    }


}
extension RentMoneyCell: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        rentMoneyTextField.adjustsFontSizeToFitWidth=true  //当文字超出文本框宽度时，自动调整文字大小
       rentMoneyTextField.minimumFontSize = 14  //最小可缩小的字号
        rentMoneyTextField.keyboardType = .NumberPad
        
        
        
        
        return true
    }
    func textFieldShouldReturn(textField:UITextField) -> Bool
    {
        //收起键盘
        textField.resignFirstResponder()
        rentMoneyTextField.text = textField.text
        FIRAnalytics.logEventWithName("rentMoney_rentDayLimit", parameters: ["rentMoney_value": textField.text! ])
        return true;
    }
    
    
}
