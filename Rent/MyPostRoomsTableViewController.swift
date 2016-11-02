//
//  MyPostRoomsTableViewController.swift
//  Rent
//
//  Created by apple on 2016/10/24.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

class MyPostRoomsTableViewController: UITableViewController {
    
    @IBOutlet var myTableView: UITableView!
    var postDatas = [PostData]()
  
    @IBAction func backSettingButton(sender: AnyObject) {
          self.navigationController?.popViewControllerAnimated(true)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "我的刊登"

        //        DataService.dataService.POST_REF.queryOrderedByKey().observeEventType(.ChildRemoved, withBlock: { (snappost) in
        //            print(snappost.value)
        //            print(snappost.key)
        ////            print(self.postDictionary)
        //            self.postDictionary.removeValueForKey(snappost.key)
        //            self.myTableView.reloadData()
        //            })
        DataService.dataService.fetchMyPostRoom { (snap) in
            self.postDatas.append(snap)
            
            let indexPath = NSIndexPath(forRow: self.postDatas.count - 1 , inSection: 0)
            self.myTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            dispatch_async(dispatch_get_main_queue(), {
                
                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                
                self.myTableView.reloadData()
                
                hud.hideAnimated(true)
            })
        }
//     DataService.dataService.POST_REF.observeSingleEventOfType(.ChildRemoved, withBlock: { (snappost) in
//        self.postDictionary.removeValueForKey(snappost.key)
//        self.myTableView.reloadData()
//        })
//        
        
    }
  
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return  postDatas.count
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = myTableView.dequeueReusableCellWithIdentifier("cellMyPostRoom", forIndexPath: indexPath) as? MyPostRoomsCell else{fatalError()}
        let post = postDatas[indexPath.row]
        
        
        dispatch_async(dispatch_get_main_queue(), {
            cell.configureCell(post)
        })
        
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(
            indexPath, animated: false)
 }
    
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    var postDictionary = [String:PostData]()
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        
      let  post = postDatas[indexPath.row]
  
      
        if editingStyle == .Delete
        {
            guard let currentuser = DataService.dataService.currentUser?.uid else{fatalError()}
            
            if let chatPartnerId = post.id{
                DataService.dataService.PEOPLE_REF.child(currentuser).child("myPostRooms").child(chatPartnerId).removeValueWithCompletionBlock({ (error, ref) in
                    
                    DataService.dataService.POST_REF.child(chatPartnerId).removeValueWithCompletionBlock({ (error, ref) in
                        
                        if error != nil {
                            print("Failed to delete message:", error)
                            return
                        }
                        self.postDatas.removeAtIndex(indexPath.row)
                        self.myTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//                        self.myTableView.reloadData()

              
//                self.myTableView.reloadData()
                })
                    
                })
                
            }
           }
    }
    
}
