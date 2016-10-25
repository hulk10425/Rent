//
//  SelectAdditionalCostViewController.swift
//  Renter
//
//  Created by apple on 2016/10/4.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit

class SelectAdditionalCostViewController: UIViewController {

    var additionalCostArray: [String] = ["水費","電費","網路費","管理費","清潔費","第四台","瓦斯費"]
    @IBOutlet weak var myTableView: UITableView!
     var selectedIndexs = [Int]()
    var checked = Bool()
    @IBOutlet weak var saveAdditionalButton: UIButton!
    var delegate: SecondVCDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.allowsMultipleSelection = true
        saveAdditionalButton.addTarget(self, action: #selector(save(_:)), forControlEvents: .TouchUpInside)
        
 
    }
    
   

    
    
    func save(sender: UIButton){
     
        if let selectedItems = myTableView.indexPathsForSelectedRows {
            selectedIndexs = []
            for indexPath in selectedItems {
              selectedIndexs.append(indexPath.row)
                
            }
                            
        }
       for index in selectedIndexs {
      
             delegate?.passAddtiionalCost(additionalCostArray[index])
       
        }
        dismissViewControllerAnimated(true, completion: nil)
       
       
    }
    
    

}
extension SelectAdditionalCostViewController: UITableViewDataSource{
    //表格的列數
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return additionalCostArray.count
    }
    //設定表格只有一個區段
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = myTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? SelectAdditionalCell else{fatalError()}
       
        cell.additionalCostText.text = additionalCostArray[indexPath.row]
        
        
        return cell
    }
    
    
}

extension SelectAdditionalCostViewController: UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
 guard let cell = self.myTableView.cellForRowAtIndexPath(indexPath) as? SelectAdditionalCell else{fatalError()}

          cell.accessoryType = .Checkmark

    }
    //取消選中的checkmark
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = self.myTableView.cellForRowAtIndexPath(indexPath) as? SelectAdditionalCell else{fatalError()}
      cell.accessoryType = .None
}
    
    
    
    
}

