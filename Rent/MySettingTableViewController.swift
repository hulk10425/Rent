//
//  MySettingTableViewController.swift
//  Rent
//
//  Created by apple on 2016/11/3.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit

class MySettingTableViewController: UIViewController {
  var myUserDefaluts: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    @IBAction func backButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    @IBOutlet weak var switchNotification: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        switchNotification.addTarget(self, action: #selector(stateChanged(_:)), forControlEvents: .ValueChanged)
        
     switchNotification.on = true
     switchNotification.on =  myUserDefaluts.boolForKey("switchstate")
      
        
        
    }

   

    func stateChanged(switchState: UISwitch) {
        let application = UIApplication.sharedApplication()
        if switchState.on {
       
            application.registerForRemoteNotifications()
            
        } else {
           
            application.unregisterForRemoteNotifications()
        }
        myUserDefaluts.setBool(switchState.on, forKey: "switchstate")
        myUserDefaluts.synchronize()
    }
    

}
