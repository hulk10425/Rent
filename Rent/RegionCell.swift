//
//  RegionCell.swift
//  Renter
//
//  Created by apple on 2016/9/30.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class RegionCell: UITableViewCell, UITextFieldDelegate, UIActionSheetDelegate {
    @IBOutlet weak var regionField: UITextField!
    var cityArray = ["台北市"]
    var regionArray = ["中正區","大同區","中山區","松山區","大安區","萬華區","信義區","士林區","北投區","內湖區","南港區","文山區"]
  
    @IBOutlet weak var regionButton: UIButton!
   override func awakeFromNib() {
        regionField.delegate = self
    
     regionButton.addTarget(self, action: #selector(selectClicked(_:)), forControlEvents: .TouchUpInside)
    
//    let img = UIImage(named: "arrows")
    
//    self.regionField.rightView = UIImageView(image: img)
//    self.regionField.rightViewMode = UITextFieldViewMode.Always
//    
    
    }
    
    func selectClicked(sender: UIButton){
        
        let acp = ActionSheetMultipleStringPicker(title: "區域選擇", rows: [cityArray,regionArray], initialSelection: [1, 1], doneBlock:  {
           picker, values, index in
            
        
    

            
            self.regionField.text = String(values)
            
            print("values = \(index)")
            //                print("indexes = \(indexes)")
                            print("picker = \(picker)")
            return
            }, cancelBlock: { ActionStrinMultipleCancelBlock in return }, origin: sender.superview)
      
        
        acp.showActionSheetPicker()
    }
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        // selected value in Uipickerview in Swift
        let value = cityArray[row]
        print("values:----------\(value)");
        
    }
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return false
    }
    //不讓使用者透過建盤輸入文字
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
  }
