//
//  SelectViewController.swift
//  Renter
//
//  Created by apple on 2016/9/23.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import MBProgressHUD
import MJRefresh






let loadingView: UIView = UIView()
class SelectViewController: UIViewController, QueryDelegate {
    var detailVC = PostDetailData()
    @IBOutlet weak var addEvent: UIButton!
    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBAction func backButton(sender: AnyObject) {
        
        let actionSheetController = UIAlertController(title: "Please select", message: "Option to select", preferredStyle: .ActionSheet)
        
        let cancleActionButton = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            print("cancel")
        }
        actionSheetController.addAction(cancleActionButton)
        
        //        let profileAction = UIAlertAction(title: "Profile", style: .Default) { (action) in
        //            print("change to Profile")
        //            let profileVC = self.storyboard?.instantiateViewControllerWithIdentifier("EditProfile") as! ProfileTableView
        //            self.navigationController?.pushViewController(profileVC, animated: true)
        //        }
        //        actionSheetController.addAction(profileAction)
        //
        
        let logoutAction = UIAlertAction(title: "Log Out", style: .Default) { (action) in
            print("lout out")
            self.logoutDidTapped()
        }
        actionSheetController.addAction(logoutAction)
        
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        
    }
    func logoutDidTapped(){
        DataService.dataService.logout()
    }
    
    var post:PostData!
    
    var cellPostData = ShowPostDataCell()
    var postDatas = [PostData]()
    var postDictionary = [String:PostData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "找室友"
        
        //跳轉到新增室有條件頁面
        addEvent.addTarget(self, action: #selector(SelectViewController.toSelectManPage(_:)), forControlEvents: .TouchUpInside )
        
        
        let nib = UINib(nibName: "ShowPostData", bundle: nil)
        myTableView.registerNib(nib, forCellReuseIdentifier: "cellPostData")
        
      
        
                self.postDatas = []
        DataService.dataService.fetchPostData { (snap) in
            self.postDatas.append(snap)
            
            
            
            dispatch_async(dispatch_get_main_queue(), {
                
                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                
                self.myTableView.reloadData()
                
                hud.hideAnimated(true)
                
            })
        }
//        
//        DataService.dataService.POST_REF.observeEventType(.ChildRemoved, withBlock:  { (snap) in
////            let post = PostData(key: snap.key, snapshot: snap.value as! Dictionary<String, AnyObject>)
//            
// 
//          
//          
////            self.postDatas = self.postDictionary
//            self.myTableView.reloadData()
//    })
        let indexPath = NSIndexPath(forRow: self.postDatas.count - 1 , inSection: 0)
        self.myTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
  

        
    }
    
    func alert(){
        let alertController = UIAlertController(
            title: "警告！！！",
            message: "你必須註冊帳號",
            preferredStyle: .Alert)
        
        // 建立[取消]按鈕
        let cancelAction = UIAlertAction(
            title: "取消",
            style: .Cancel,
            handler: nil)
        alertController.addAction(cancelAction)
        
        // 建立[送出]按鈕
        let okAction = UIAlertAction(
            title: "確定",
            style: .Default,
            handler: nil)
        alertController.addAction(okAction)
        
        // 顯示提示框
        self.presentViewController(alertController,animated: true, completion: nil)
        
        
        
    }
    //排序篩選條件
    func queryData(value: [PostData]) {
        
        self.postDatas = value
        
        dispatch_async(dispatch_get_main_queue(), {
            
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            
            self.myTableView.reloadData()
            
            hud.hideAnimated(true)
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    func toSelectManPage(sender:UIButton){
        
        
        self.hidesBottomBarWhenPushed = true
        performSegueWithIdentifier("toSelectManPage", sender:sender)
        self.hidesBottomBarWhenPushed = false
        
    }
    //跳轉到聊天室
    func toChatViewPage(sender:UIButton){
        guard let currentuser = DataService.dataService.currentUser?.uid else{return}
        if currentuser != ""{
            self.hidesBottomBarWhenPushed = true
            performSegueWithIdentifier("ChatSegue", sender: sender)
            self.hidesBottomBarWhenPushed = false
            
        }else{
            alert()
            
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        
        if segue.identifier == "ChatSegue"{
            if let clickBtnChat:UIButton = sender as? UIButton{
                guard let chatViewController = segue.destinationViewController as? ChatViewController else{
                    
                    fatalError()
                }
                //點擊button取得對應得值
                chatViewController.roomId = self.postDatas[clickBtnChat.tag].id
                chatViewController.roomTitle = self.postDatas[clickBtnChat.tag].title
            }
            
        }
        
        if segue.identifier == "toPostDetailData"{
            guard let senderCell = sender as? UITableViewCell else{
                //先讓App Crash
                return
            }
            if let tableviewCellIndoxPath = myTableView!.indexPathForCell(senderCell){
                guard let detailController = segue.destinationViewController as? PostDetailData else{
                    return
                }
                detailVC = detailController
                detailVC.detailInfo = postDatas[tableviewCellIndoxPath.row]
                
                
            }
            
            
        }
    }
    
    
    @IBOutlet weak var queryButton: UIButton!
    
    @IBAction func queryButton(sender: AnyObject) {
        let queryController = self.storyboard?.instantiateViewControllerWithIdentifier("queryData") as! QueryDataTableViewController
        queryController.delegete = self
        
        
        let nav = UINavigationController(rootViewController: queryController)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        
        let height = queryController.querydataArray.count * 44
        queryController.preferredContentSize = CGSize(width: 300, height: height)
        
        let popover = nav.popoverPresentationController
        popover!.delegate = self
        popover!.sourceView = queryButton
        popover!.sourceRect = queryButton.bounds
        
        
        
        self.presentViewController(nav, animated: true, completion: nil)
        
        
        
        
    }
    
    
}

extension SelectViewController:  UITableViewDataSource{
    //表格的列數
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.postDatas.count
    }
    //設定表格只有一個區段
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    //設定儲存格的內容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = myTableView.dequeueReusableCellWithIdentifier(
            "cellPostData",forIndexPath: indexPath) as? ShowPostDataCell else{
                fatalError()
        }
        
        
        
        let post = postDatas[indexPath.row]
        
        
        dispatch_async(dispatch_get_main_queue(), {
            cell.configureCell(post)
        })
        
        cell.toChatButton.addTarget(self, action: #selector(toChatViewPage(_:)), forControlEvents: .TouchUpInside)
        cell.toChatButton.tag = indexPath.row
        
        return cell
        
    }
    
    
}



//表格視圖的代理
extension SelectViewController:  UITableViewDelegate {
    
    
    // 點選 cell 後執行的動作
    func tableView(tableView: UITableView,
                   didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 取消 cell 的選取狀態
        tableView.deselectRowAtIndexPath(
            indexPath, animated: false)
        
        let cell = myTableView.cellForRowAtIndexPath(indexPath)
        self.hidesBottomBarWhenPushed = true
        self.performSegueWithIdentifier("toPostDetailData", sender: cell)
        self.hidesBottomBarWhenPushed = false
    }
    
    
}

extension SelectViewController: UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}


