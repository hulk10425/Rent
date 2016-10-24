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
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source



    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return settingArray.count
    }
    override func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            
            let cell =
                tableView.dequeueReusableCellWithIdentifier(
                    "cellSetting", forIndexPath: indexPath) as
            UITableViewCell
            cell.textLabel?.text = settingArray[indexPath.row]
            return cell
    }


  

}
