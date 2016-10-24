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

protocol QueryDelegate: class {
    func queryData(value:[PostData])
}



class QueryDataTableViewController: UITableViewController {
    
    @IBOutlet var myTableView: UITableView!
    weak var delegete: QueryDelegate?
    
    var querydataArray = ["租金從高到低","租金從低到高"]
    var postDatas = [PostData]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.dataService.fetchPostData { (snap) in
            self.postDatas.append(snap)
    
        }
        
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
            cell.textLabel?.text = querydataArray[indexPath.row]
            return cell
    }
    
    override func tableView(tableView: UITableView,
                            didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 取消 cell 的選取狀態
        tableView.deselectRowAtIndexPath(
            indexPath, animated: true)
      
        switch indexPath.item {
        case 0:
            self.postDatas.sortInPlace({ (post1, post2) -> Bool in
                
                return post1.rentMoney > post2.rentMoney
            })
        self.delegete?.queryData(self.postDatas)
        default :
            self.postDatas.sortInPlace({ (post1, post2) -> Bool in
                
                return post1.rentMoney < post2.rentMoney
            })
        self.delegete?.queryData(self.postDatas)
        }
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
}



