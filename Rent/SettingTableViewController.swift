//
//  SettingTableViewController.swift
//  Rent
//
//  Created by apple on 2016/10/24.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    var settingArray = ["我的資料","我的刊登","設定"]
    
    @IBOutlet var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return settingArray.count
    }
    override func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            
            let cell =
                tableView.dequeueReusableCellWithIdentifier(
                    "cellSetting", forIndexPath: indexPath) as
            UITableViewCell
            cell.textLabel?.textColor = UIColor.grayColor()
            cell.textLabel?.text = settingArray[indexPath.row]
            return cell
    }
    override func tableView(tableView: UITableView,
                            didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 取消 cell 的選取狀態
        tableView.deselectRowAtIndexPath(
            indexPath, animated: true)
        let cell = myTableView.cellForRowAtIndexPath(indexPath)
        
        switch indexPath.item {
        case 0:
            self.hidesBottomBarWhenPushed = true
            
            
            
            self.performSegueWithIdentifier("toProfile", sender: cell)
            self.hidesBottomBarWhenPushed = false
        case 1:
            self.hidesBottomBarWhenPushed = true
            
            
            
            self.performSegueWithIdentifier("toMyPostRooms", sender: cell)
            self.hidesBottomBarWhenPushed = false
        default :
            return
        }
        
        
        
        
        
    }
    
    
    
    
    
}
