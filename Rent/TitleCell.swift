//
//  TitleCell.swift
//  Renter
//
//  Created by apple on 2016/10/3.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit

class TitleCell: UITableViewCell {
    
    @IBOutlet weak var titleTextField: UITextField!
   

    
    override func awakeFromNib() {
           titleTextField.delegate = self
    }
}


extension TitleCell: UITextFieldDelegate{

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        titleTextField.adjustsFontSizeToFitWidth=true  //当文字超出文本框宽度时，自动调整文字大小
        titleTextField.minimumFontSize = 14  //最小可缩小的字号
        titleTextField.keyboardType = .Default
        
    
     
        
        return true
    }
    func textFieldShouldReturn(textField:UITextField) -> Bool
    {
        //收起键盘
        textField.resignFirstResponder()
        titleTextField.text = textField.text

        return true;
    }


}
