//
//  QueryDataTableViewController.swift
//  Renter
//
//  Created by apple on 2016/10/13.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit
import Firebase
import MBProgressHUD

class QueryDataTableViewController: UITableViewController {
    
 
    var querydataArray = ["租金從高到低","租金從低到高"]
    var postDatas = [PostData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        queryMoneyLowToTall.addTarget(self, action: #selector(queryLowToTall(_:)), forControlEvents: .TouchUpInside)
      
    }
    
    override func tableView(tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {

        return querydataArray.count
    }
   override func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
           
            let cell =
                tableView.dequeueReusableCellWithIdentifier(
                    "cellQuery", forIndexPath: indexPath) as
            UITableViewCell
            

          
            return cell
    }
//    
//     override func tableView(tableView: UITableView,
//                   didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        // 取消 cell 的選取狀態
//        tableView.deselectRowAtIndexPath(
//            indexPath, animated: true)
//        
//        
//        
//        
//    }


//    
//    func queryLowToTall(sender: UIButton){
//    
//        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        DataService.dataService.POST_REF.queryOrderedByChild("rentMoney").observeEventType(.ChildChanged, withBlock: { (snapshot) in
//            MBProgressHUD.hideHUDForView(self.view, animated: true)
//            
//            let post = PostData(key: snapshot.key, snapshot: snapshot.value as! Dictionary<String, AnyObject>)
//            self.postDatas.append(post)
//            let cell = SelectManViewController()
//            
//            
//            let indexPath = NSIndexPath(forRow: self.postDatas.count - 1 , inSection: 0)
//            cell.myTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//            dispatch_async(dispatch_get_main_queue(), {
//              cell.myTableView.reloadData()
//               
//            })
//        })
//        
//            dismissViewControllerAnimated(true, completion: nil)
//    
//    }
//    

}

