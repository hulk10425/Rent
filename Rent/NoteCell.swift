//
//  NoteCell.swift
//  Renter
//
//  Created by apple on 2016/10/3.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {
     var myUserDefaluts: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var noteTextView: UITextView!
  private var isKeyboardShown = false
    
    override func awakeFromNib() {
        noteTextView.delegate = self
        
       
       
    }

}
extension NoteCell: UITextViewDelegate{

// 
//    func textViewShouldEndEditing(textView: UITextView) -> Bool {
//         noteTextView.resignFirstResponder()
//
//        return true
//    }
    func textViewDidBeginEditing(textView: UITextView) {
      
        
        textView.text = ""
    }
    
    
    func textViewDidEndEditing(textView: UITextView) {
       
       
        if textView.text == ""{
        textView.text = "請輸入備註"
        }else{
       
            noteTextView.resignFirstResponder()
//            noteTextView.text = textView.text
            myUserDefaluts.setObject(textView.text, forKey: "noteView")
            myUserDefaluts.synchronize()
        }

//        
 
    }
    
    
   

  
    func sizeOfString (string: String, constrainedToWidth width: Double, font: UIFont) -> CGSize {
        return (string as NSString).boundingRectWithSize(CGSize(width: width, height: DBL_MAX), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil).size
        
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).stringByReplacingCharactersInRange(range, withString: text)
        var textWidth = CGRectGetWidth(UIEdgeInsetsInsetRect(textView.frame, textView.textContainerInset))
        textWidth -= 2.0 * textView.textContainer.lineFragmentPadding
        
        let boundingRect = sizeOfString(newText, constrainedToWidth: Double(textWidth), font: textView.font!)
        let numberOfLines = boundingRect.height / textView.font!.lineHeight
        
        if numberOfLines >= 3 {
            noteTextView.scrollEnabled = true
            return true
        }
        noteTextView.scrollEnabled = false
        return numberOfLines <= 3
    }


}