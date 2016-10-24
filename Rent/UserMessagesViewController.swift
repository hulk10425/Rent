//
//  UserMessagesViewController.swift
//  Renter
//
//  Created by apple on 2016/10/15.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class UserMessagesViewController: UIViewController{
    
    @IBOutlet weak var myTableView: UITableView!
    var room: PostData!
    
    @IBOutlet weak var noMessageView: UIView!
    
    var messages: [Chats] = []
    
    //    var chats: [Chat] = []
    var postDatas = [PostData]()
    
    var cellUserMessageCell = UserMessageCell()
    var messageDictionary = [String: Chats]()
    var array: [AnyObject]!
    override func viewDidLoad() {
        super.viewDidLoad()
        DataService.dataService.fetechUserMessage { (messagesnap) in
            let messageDictionary = messagesnap.value as? Dictionary<String,AnyObject>
            
            let newMessage = Chats()
            newMessage.setValuesForKeysWithDictionary(messageDictionary!)
            self.messages.append(newMessage)
            if self.messages.count < 1 {
                self.noMessageView.hidden = false
            }else{
                
                self.noMessageView.hidden = true
            }
            
            if let roomId = newMessage.roomId {
                self.messageDictionary[roomId] = newMessage
                self.messages = Array(self.messageDictionary.values)
                self.messages.sortInPlace({ (message1, message2) -> Bool in
                    
                    return message1.date.intValue > message2.date.intValue
                })
                dispatch_async(dispatch_get_main_queue(), {
                    self.myTableView.reloadData()
                })
                
                
            }
        }
        
        
        
        
    }
    func showChatControllerForUser(user: User) {
        let chatLogController = self.storyboard?.instantiateViewControllerWithIdentifier("ChatViewController") as! ChatViewController
        
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    
}

extension UserMessagesViewController: UITableViewDataSource{
    //表格的列數
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        return messages.count
        
    }
    //設定表格只有一個區段
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //
        //
        let message = messages[indexPath.row].message
        let meseeageRoom = messages[indexPath.row].roomId
        
        let cell =  self.myTableView.dequeueReusableCellWithIdentifier("cellMessage", forIndexPath: indexPath) as! UserMessageCell
        self.cellUserMessageCell = cell
        
        DataService.dataService.POST_REF.queryOrderedByKey().queryEqualToValue(meseeageRoom).observeEventType(.Value, withBlock: { (snap) in
            let roomsnap = snap.value as! [String:AnyObject]
            
            for value in roomsnap.values{
                let roomImage = value["image"] as! String
                let roomTitle = value["title"] as! String
                if roomImage.hasPrefix("gs://"){
                    cell.userMessageImage.kf_setImageWithURL(NSURL(string: roomImage))
                    FIRStorage.storage().referenceForURL(roomImage).dataWithMaxSize(INT64_MAX, completion: { (data, error) in
                        if let error = error{
                            print(error)
                            return
                        }
                        cell.userMessageImage.image = UIImage.init(data: data!)
                    })
                }
                
                cell.userMessageNameLabel.text = roomTitle
                
                
            }
            
            
        })
        
        
        
        
        let seconds = self.messages[indexPath.row].date.doubleValue
        let timestampDate = NSDate(timeIntervalSince1970: seconds)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM月dd日,hh:mm a"
        
        cell.userMessageTimeLabel.text = dateFormatter.stringFromDate(timestampDate)
        cell.userMessageLabel.text = message
        
        
        
        
        return cellUserMessageCell
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toChatView" {
            guard let senderCell = sender as? UITableViewCell else{
                //先讓App Crash
                fatalError()
            }
            if let tableviewCellIndoxPath = myTableView!.indexPathForCell(senderCell){
                
                guard let chatViewController = segue.destinationViewController as? ChatViewController else{
                    fatalError()
                }
                chatViewController.roomId = messages[tableviewCellIndoxPath.row].roomId
                
                
            }
            
            
        }
    }
    
}

extension UserMessagesViewController: UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // 取消 cell 的選取狀態
        tableView.deselectRowAtIndexPath(
            indexPath, animated: false)
        let cell = myTableView.cellForRowAtIndexPath(indexPath)
        //push後隱藏tabbar 
        self.hidesBottomBarWhenPushed = true
        self.performSegueWithIdentifier("toChatView", sender: cell)
        self.hidesBottomBarWhenPushed = false
    }
    
}


