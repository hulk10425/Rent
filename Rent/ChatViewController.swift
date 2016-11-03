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
    
    
    
    @IBOutlet weak var chatView: UIView!
    
    @IBAction func backHomePage(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    static let shared = ChatViewController()
    
    
    override func viewDidLoad() {
        
        chatView.layer.borderWidth = 1.0
        chatView.layer.borderColor = UIColor.blackColor().CGColor
        
        self.navigationItem.title = roomTitle
    
        messageTextField.delegate = self
        DataService.dataService.POST_REF.child(roomId).observeSingleEventOfType(.Value, withBlock: {(snapshot)in
            
            
            
            DataService.dataService.MESSAGE_REF.observeEventType(.ChildAdded, withBlock: {(snap)in
                
                let dictionary = snap.value as! Dictionary<String,AnyObject>
                
                if snapshot.key ==  dictionary["roomId"] as! String {
                    self.messages.append(snap)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                    
                    
                }
                
            })
            
        })
        
        
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
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        
    }
    
    
    
    
    
    @IBOutlet weak var constaint: NSLayoutConstraint!
    
    
    func showOrHideKeyboard(notification: NSNotification){
        if let keyboardInfo: Dictionary = notification.userInfo{
            
            if notification.name == UIKeyboardWillShowNotification{
                UIView.animateWithDuration(1, animations: {
                    () in
                    self.constaint.constant = (keyboardInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().height
                    self.view.layoutIfNeeded()
                }){ (completed: Bool) -> Void in
                    
                    self.moveToLastMessage()
                }
            }else if notification.name == UIKeyboardWillHideNotification{
                UIView.animateWithDuration(1, animations: {
                    () in
                    self.constaint.constant = 0
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
    
    func moveToLastMessage(){
        if self.tableView.contentSize.height > CGRectGetHeight(self.tableView.frame){
            let contentOfSet = CGPointMake(0, self.tableView.contentSize.height - CGRectGetHeight(self.tableView.frame))
            self.tableView.setContentOffset(contentOfSet, animated: true)
            
        }
        
    }
    @IBAction func SendButtonDidTapped(sender: AnyObject) {
        self.messageTextField.resignFirstResponder()
        
        if let user = FIRAuth.auth()?.currentUser{
            let currentDate: NSNumber = Int(NSDate().timeIntervalSince1970)
            DataService.dataService.CreateNewMessage(user.uid, roomId: roomId, textMessage: messageTextField.text!, date: currentDate)
            
            DataService.dataService.POST_REF.child(roomId).observeSingleEventOfType(.Value, withBlock: {(snapshot)in
                DataService.dataService.PARTICIPANTS_REF.child(snapshot.key).observeSingleEventOfType(.Value, withBlock: { (snappart) in
                    let dictionary = snappart.value as! Dictionary<String,AnyObject>
                    
                    
                    let keys = Array(dictionary.keys)
                    for roomId in keys{
                        DataService.dataService.PEOPLE_REF.child(roomId).child("token").observeSingleEventOfType(.Value, withBlock: { (snap) in
                            
//                            var badgeCount = UIApplication.sharedApplication().applicationIconBadgeNumber
//                            badgeCount = badgeCount + 1
                            
                            let body = [ "to": snap.value!,
                                "priority" : "high",
                                "notification" : [ "title": self.roomTitle,
                                    "body" : self.messageTextField.text!,
                                    "sound": "default",
                                                              ]
                            ]
                            
                            let url = NSURL(string: "https://fcm.googleapis.com/fcm/send")
                            let mutableURLRequest = NSMutableURLRequest(URL: url!)
                            let session = NSURLSession.sharedSession()
                            do {
                                let jsonBody = try NSJSONSerialization.dataWithJSONObject(body, options: .PrettyPrinted)
                                mutableURLRequest.HTTPMethod = "POST"
                                mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                mutableURLRequest.setValue("key=AIzaSyAg-yUNww4bEaOYSuuTlMlLn5BTjfwYrFk", forHTTPHeaderField: "Authorization")
                                mutableURLRequest.HTTPBody = jsonBody
                                let task = session.dataTaskWithRequest(mutableURLRequest) {
                                    ( data , response, error ) in
                                    let httpResponse = response as! NSHTTPURLResponse
                                    let statusCode = httpResponse.statusCode
                                    print("STATUS CODE: \(statusCode)")
                                }
                                
                                task.resume()
                                
                            } catch {
                                
                                print(error)
                            }
                            
                            self.messageTextField.text = nil
                        })
                        
                        
                    }
                })
            })
            
        }else{
            print("no none sign in")
        }
        
        
    }
    
    
    
}
var messageId: String!
extension ChatViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        
        
        let messageSnapshot = messages[indexPath.row]
        let message = messageSnapshot.value as! Dictionary<String, AnyObject>
        messageId = message["senderId"] as! String
        
        
        if  messageId  == DataService.dataService.currentUser?.uid {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellMessageSent, forIndexPath: indexPath) as! ChatViewCell
            cell.configCell(messageId, message: message)
            
            cell.triangle.image = cell.triangle.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            cell.triangle.tintColor = UIColor(r: 255, g: 156, b: 0)
            
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