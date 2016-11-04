//
//  MySettingTableViewController.swift
//  Rent
//
//  Created by apple on 2016/11/3.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit

class MySettingTableViewController: UIViewController {

    @IBAction func backButton(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    @IBOutlet weak var switchNotification: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        //switchNotification.addTarget(self, action: #selector(stateChanged(_:)), forControlEvents: .ValueChanged)
       
    }

   

//    func stateChanged(switchState: UISwitch) {
//        let application = UIApplication.sharedApplication()
//        if switchState.on {
//            switchNotification.setOn(true, animated: true)
//            application.registerForRemoteNotifications()
//            
//        } else {
//            switchNotification.setOn(false, animated: false)
//
//            application.unregisterForRemoteNotifications()
//        }
//        
//    }
    

}
