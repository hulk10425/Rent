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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "我的刊登"
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
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
        
        
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
    
   override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete
        {
           postDatas.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
        }
    }
}
