//
//  RegionCell.swift
//  Renter
//
//  Created by apple on 2016/9/30.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit


class RegionCell: UITableViewCell{
    @IBOutlet weak var regionField: UITextField!
   

   override func awakeFromNib() {
        regionField.delegate = self
     }
    
//    func selectClicked(sender: UIButton){
//        
//        let acp = ActionSheetMultipleStringPicker(title: "區域選擇", rows: [cityArray,regionArray], initialSelection: [1, 1], doneBlock:  {
//           picker, values, index in
//            
//        
//    
//
//            
//            self.regionField.text = String(values)
//            
//            print("values = \(index)")
//            //                print("indexes = \(indexes)")
//                            print("picker = \(picker)")
//            return
//            }, cancelBlock: { ActionStrinMultipleCancelBlock in return }, origin: sender.superview)
//      
//        
//        acp.showActionSheetPicker()
//    }
//    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
//    {
//        // selected value in Uipickerview in Swift
//        let value = cityArray[row]
//        print("values:----------\(value)");
//        
//    }
  }
extension RegionCell: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        regionField.adjustsFontSizeToFitWidth=true  //当文字超出文本框宽度时，自动调整文字大小
        regionField.minimumFontSize = 14  //最小可缩小的字号
        regionField.keyboardType = .Default
        
        
        
        
        return true
    }
    func textFieldShouldReturn(textField:UITextField) -> Bool
    {
        //收起键盘
        textField.resignFirstResponder()
        regionField.text = textField.text
        
        return true
    }
}

