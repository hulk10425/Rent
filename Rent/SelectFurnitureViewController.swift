//
//  SelectFurnitureViewController.swift
//  Renter
//
//  Created by apple on 2016/9/30.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit

protocol SecondVCDelegate: class{
    
    func passFurniture(value:String)
    func passAddtiionalCost(value:String)
}

class SelectFurnitureViewController: UIViewController {
    var furnitureArray = ["冰箱","電視","洗衣機","熱水器","廚房","無線網路","微波爐","飲水機","除濕機"]
    @IBOutlet weak var myTableView: UITableView!

    weak var delegate: SecondVCDelegate?

    var array = [AnyObject]()
    var selectedIndexs = [Int]()
    @IBOutlet weak var saveFurniture: UIButton!
 

 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.allowsMultipleSelection = true
        saveFurniture.addTarget(self, action: #selector(save(_:)), forControlEvents: .TouchUpInside)


        
    }
        func save(sender: UIButton){
            
            if let selectedItems = myTableView.indexPathsForSelectedRows {
                for indexPath in selectedItems {
                    selectedIndexs.append(indexPath.row)
                }
               
            }
            
            for index in selectedIndexs {
                delegate?.passFurniture(furnitureArray[index])
            }
            dismissViewControllerAnimated(true, completion: nil)
            
            
        }
    

    
}

extension SelectFurnitureViewController: UITableViewDataSource{
    //表格的列數
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return furnitureArray.count
    }
    //設定表格只有一個區段
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = myTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? SelectFurnitureCell else{fatalError()}
    
    cell.furnitureText.text = furnitureArray[indexPath.row]
       
 
        return cell
    }
  

}

extension SelectFurnitureViewController: UITableViewDelegate{
   func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
  
    guard let cell = self.myTableView.cellForRowAtIndexPath(indexPath) as? SelectFurnitureCell else{fatalError()}

  cell.accessoryType = .Checkmark
   
    
   
    }
  
    
     func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
           guard let cell = self.myTableView.cellForRowAtIndexPath(indexPath) as? SelectFurnitureCell else{fatalError()}
          cell.accessoryType = .None
    }



 


}
