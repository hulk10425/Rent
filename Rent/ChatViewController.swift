//
//  ChatViewController.swift
//  Renter
//
//  Created by apple on 2016/9/24.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit

import Firebase
import MBProgressHUD


private struct Constants{
    static let cellIdMessageRecieved = "MessageCellMe"
    static let cellMessageSent = "MessageCellYou"
    
}



class ChatViewController: UIViewController, UITextFieldDelegate {
    var ref: FIRDatabaseReference!
    var roomTitle: String!
    var roomId: String!
    var messages: [FIRDataSnapshot] = []
    
  
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    static let shared = ChatViewController()
    
    
    override func viewDidLoad() {
        
        self.navigationItem.title = roomTitle
        
        DataService.dataService.POST_REF.child(roomId).observeSingleEventOfType(.Value, withBlock: {(snapshot)in
            // print(snapshot.key)
            
            
            DataService.dataService.MESSAGE_REF.observeEventType(.ChildAdded, withBlock: {(snap)in
               
                let dictionary = snap.value as! Dictionary<String,AnyObject>
                print(dictionary)
                if snapshot.key ==  dictionary["roomId"] as! String {
                    self.messages.append(snap)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                    
                    //                    print(self.messages)
                }
                
            })
            
        })
        
        
        //
        //        DataService.dataService.fetechMessage(roomId) { (snap) in
        //            print(snap.value)
        //
        //            self.messages.append(snap)
        //
        //            //print(snap)
        //            //print(self.messages)
        //             MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //             dispatch_async(dispatch_get_main_queue(), {
        //            self.tableView.reloadData()
        //              })
        //               MBProgressHUD.hideHUDForView(self.view, animated: true)
        //          //
        
        ////
        
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return UITableViewAutomaticDimension
        default: return UITableViewAutomaticDimension
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.showOrHideKeyboard(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.showOrHideKeyboard(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object:  nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object:  nil)
        
    }
    
    
    
    @IBOutlet weak var constraintToBottom: NSLayoutConstraint!
    
    
    
    
    func showOrHideKeyboard(notification: NSNotification){
        if let keyboardInfo: Dictionary = notification.userInfo{
            
            if notification.name == UIKeyboardWillShowNotification{
                UIView.animateWithDuration(1, animations: {
                    () in
                    self.constraintToBottom.constant = (keyboardInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
                    self.view.layoutIfNeeded()
                }){ (completed: Bool) -> Void in
                    
                    self.moveToLastMessage()
                }
            }else if notification.name == UIKeyboardWillHideNotification{
                UIView.animateWithDuration(1, animations: {
                    () in
                    self.constraintToBottom.constant = 0
                    self.view.layoutIfNeeded()
                }){(completed: Bool)-> Void in}
                self.moveToLastMessage()
            }
            
        }
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        
    }
    
    func moveToLastMessage(){
        if self.tableView.contentSize.height > CGRectGetHeight(self.tableView.frame){
            let contentOfSet = CGPointMake(0, self.tableView.contentSize.height - CGRectGetHeight(self.tableView.frame))
            self.tableView.setContentOffset(contentOfSet, animated: true)
            
        }
        
    }
    @IBAction func SendButtonDidTapped(sender: AnyObject) {
        self.messageTextField.resignFirstResponder()
        if messageTextField != "" {
            if let user = FIRAuth.auth()?.currentUser{
                let currentDate: NSNumber = Int(NSDate().timeIntervalSince1970)
                
                
                
                
                
                DataService.dataService.CreateNewMessage(user.uid, roomId: roomId, textMessage: messageTextField.text!, date: currentDate)
            }else{
                print("no none sign in")
            }
            self.messageTextField.text = nil
            
        }else{
            
            print("error: Empty String")
        }
    }
    //    private func estimateFrame(text: String) -> CGRect{
    //    let size = CGSize(width: 200, height: 1000)
    //        let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
    //       return NSString(string:text).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName : UIFont.systemFontSize(16)]?, context: nil)
    //    }
    //
    
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        
        
        let messageSnapshot = messages[indexPath.row]
        let message = messageSnapshot.value as! Dictionary<String, AnyObject>
        
        let messageId = message["senderId"] as! String
//        print(messageId)
        //self.delegate?.passSenderId(messageId)
        
        
        if  messageId  == DataService.dataService.currentUser?.uid {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellMessageSent, forIndexPath: indexPath) as! ChatViewCell
            cell.configCell(messageId, message: message)
            
            cell.triangle.image = cell.triangle.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            cell.triangle.tintColor = UIColor(red: 199/255, green: 232/255, blue: 255/255, alpha: 1)
            
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellIdMessageRecieved, forIndexPath: indexPath) as! ChatViewCell
            cell.configCell(messageId, message: message)
            cell.triangle.image = cell.triangle.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            cell.triangle.tintColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
            
            return cell
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
}