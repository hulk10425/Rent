//
//  NavigationViewController.swift
//  Rent
//
//  Created by apple on 2016/11/2.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit


class NavigationViewController: UINavigationController {
    var postDatas = [PostData]()

    @IBOutlet weak var selectHomemate: UITabBarItem!
    override func viewDidLoad() {
        super.viewDidLoad()

//        selectHomemate.addObserver(
//            self,
//            selector: #selector(select(_:)),
//            name: UIDeviceBatteryLevelDidChangeNotification,
//            object: nil)
        
    }
//    func select(){
//        
//        DataService.dataService.fetchPostData { (snap) in
//            self.postDatas.append(snap)
//        
//        }
//
//    }
    

}
