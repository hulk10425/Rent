//
//  PersonCell.swift
//  Renter
//
//  Created by apple on 2016/9/30.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class PersonCell: UITableViewCell, UITextFieldDelegate {
                var personArray = ["1","2","3","4"]
         @IBOutlet weak var personField: UITextField!
    var myUserDefaluts: NSUserDefaults = NSUserDefaults.standardUserDefaults()

    @IBOutlet weak var personButton: UIButton!
    override func awakeFromNib() {
        personField.delegate = self
        
        personButton.addTarget(self, action: #selector(selectClicked(_:)), forControlEvents: .TouchDown)
//        let img = UIImage(named: "arrows")
//
//        self.personField.rightView = UIImageView(image: img)
//        self.personField.rightViewMode = UITextFieldViewMode.Always
    }
    func selectClicked(sender: UIButton){
        
        let acp = ActionSheetStringPicker(title: "人數選擇", rows: self.personArray, initialSelection: 0, doneBlock: {
                picker, value, index in
                self.personField.text = String(index)
            self.myUserDefaluts.setObject("\(index)", forKey: "person")
                //                print("values = \(values)")
                //                print("indexes = \(indexes)")
                //                print("picker = \(picker)")
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
