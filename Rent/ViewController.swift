//
//  ViewController.swift
//  Renter
//
//  Created by apple on 2016/9/22.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit






class ViewController: UIViewController {


    @IBAction func logoutButton(sender: AnyObject) {
        
        let actionSheetController = UIAlertController(title: "Please select", message: "Option to select", preferredStyle: .ActionSheet)
        
        let cancleActionButton = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            print("cancel")
        }
        actionSheetController.addAction(cancleActionButton)
        
        let profileAction = UIAlertAction(title: "Profile", style: .Default) { (action) in
            print("change to Profile")
    let profileVC = self.storyboard?.instantiateViewControllerWithIdentifier("EditProfile") as! ProfileTableView
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
        actionSheetController.addAction(profileAction)
      
        
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



    @IBOutlet weak var homeSelect: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        homeSelect.addTarget(self, action: #selector(toSelectPage(_:)), forControlEvents: .TouchUpInside)
        
        
     
        
    }

   
    
    func toSelectPage(sender: UIButton){
         performSegueWithIdentifier("toSelectPage", sender:sender)
    }
    
    



}

