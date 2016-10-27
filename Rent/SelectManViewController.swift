//
//  SelectManViewController.swift
//  Renter
//
//  Created by apple on 2016/9/23.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit
import FirebaseAnalytics
import FirebaseAuth
import DKImagePickerController
import SDCycleScrollView
import MBProgressHUD



class SelectManViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    var customVC: SelectFurnitureViewController!
    let pickerController = DKImagePickerController()
    var keyHeight = CGFloat()

    @IBOutlet weak var myTableView: UITableView!
    var result = UITableViewCell()
    
    @IBAction func backButton(sender: AnyObject) {
        FIRAnalytics.logEventWithName("press_back", parameters: nil)

       self.navigationController?.popViewControllerAnimated(true)
   
    }
    
    @IBOutlet weak var saveToFirebase: UIButton!
    var selectType = UIPickerView()
    var cellDeposit = DepositCell()
    var cellFurniture = FurnitureCell()
    var cellPerson = PersonCell()
    var cellRentDay = RentDayLimit()
    var cellAdditional = RentMoneyAdditionCell()
    var cellPicture = HousePictureCell()
    var cellType = TypeCell()
    var cellTitle = TitleCell()
    var cellRentMoney = RentMoneyCell()
    let cellNote = NoteCell()
    var imageData: NSData!
  

    var myUserDefaluts: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveToFirebase.addTarget(self, action: #selector(addToFirebase(_:)), forControlEvents: .TouchUpInside)
        
        myTableView.estimatedRowHeight = 120
        myTableView.rowHeight = UITableViewAutomaticDimension
        furnitureArray = []
        additionalArray = []
        
        
       
      }
    

    
    func showPopOverFurniture(sender:UIButton) {
        
        //需要將delegate給要跳轉的controller
        guard let furniture = self.storyboard?.instantiateViewControllerWithIdentifier("Furniture") as? SelectFurnitureViewController else{return}
        
        furniture.modalPresentationStyle = .Popover
        furniture.delegate = self
        let height = furniture.furnitureArray.count * 44
        furniture.preferredContentSize = CGSize(width: 300, height: height)
        
        
        
        let popoverPresentationViewController = furniture.popoverPresentationController
        
        popoverPresentationViewController?.delegate = self
        popoverPresentationViewController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        popoverPresentationViewController?.sourceView = self.view
        
        
        popoverPresentationViewController?.sourceRect = CGRect(x:CGRectGetMidX(self.view.bounds), y: CGRectGetMidY(self.view.bounds),width: 0,height: 0)
        
        self.presentViewController(furniture, animated: true, completion: nil)
        
    }
    
    func showAdditional(sender:UIButton){
        
        let additionalCost = self.storyboard?.instantiateViewControllerWithIdentifier("AdditionalCost") as! SelectAdditionalCostViewController
        
        additionalCost.modalPresentationStyle = .Popover
        additionalCost.delegate = self
        
        let height = additionalCost.additionalCostArray.count * 44
        
        additionalCost.preferredContentSize = CGSize(width: 300, height: height)
        
        
        
        let popoverPresentationViewController = additionalCost.popoverPresentationController
        popoverPresentationViewController?.delegate = self
        popoverPresentationViewController?.sourceView = self.view
        
        
        popoverPresentationViewController?.sourceRect = CGRect(x:CGRectGetMidX(self.view.bounds), y: CGRectGetMidY(self.view.bounds),width: 0,height: 0)
        popoverPresentationViewController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        
        self.presentViewController(additionalCost, animated: true, completion: nil)
    }
    //    var env64string: String!
    var imageArray = [NSData]()
  
    //多選本地圖片
    func pickImage(sender: UIButton){
        
//        pickerController.didSelectAssets = { (assets: [DKAsset]) in
//            
//            
//            for ass in assets{
//                ass.fetchOriginalImageWithCompleteBlock({ (image, info) in
//                    self.imageData = UIImageJPEGRepresentation(image!, 0)
//                    self.imageArray.append(self.imageData)
//                    
//                    
//                    
//                    self.asset.append(image!)
//                    
//                    let cycleView = SDCycleScrollView.init(frame: CGRectMake(150, 0, 200, 100), shouldInfiniteLoop: true, imageNamesGroup:  self.asset)
//                    
//                    cycleView.autoScrollTimeInterval = 3.0
//                    dispatch_async(dispatch_get_main_queue(), {
//                        self.myTableView.addSubview(cycleView)
//                    })
//                    
//                    
//                    
//                })
//                
//            }
//            
//            
//        }
//        self.presentViewController(pickerController, animated: true) {}
        
    }
    
    func selectPhoto(sender:UIButton){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.Camera){
            imagePicker.sourceType = .Camera
        }else{
            imagePicker.sourceType = .PhotoLibrary
        }
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
       cellPicture.houseImage.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    func addToFirebase(sender: AnyObject){
      imageData =  UIImageJPEGRepresentation(cellPicture.houseImage.image!, 1.0)
        
        guard let notes = myUserDefaluts.objectForKey("noteTextView") as?String else{fatalError()}
       
        guard
            let rentDay = cellRentDay.rentDayField.text,
            person = cellPerson.personField.text,
            furniture = cellFurniture.furnitureLabel.text,
            type = cellType.typeField.text,
            deposit = cellDeposit.depositField.text,
            title = cellTitle.titleTextField.text,
            rentMoney = cellRentMoney.rentMoneyTextField.text,
            additionalCost = cellAdditional.selectAdditionalCostLabel.text else{ return}
        
        
        FIRAnalytics.logEventWithName("press_add", parameters: nil)
//        FIRAnalytics.logEventWithName("postData", parameters: [
//            "rentDay": rentDay,
//            "person": person,
//            "furniture": furniture,
//            "type":  type,
//            "deposit": deposit,
//            "rentMoney": rentMoney,
//            "additionalCost":additionalCost
//            ])
         if imageData != nil{
            DataService.dataService.CreatePostData((FIRAuth.auth()?.currentUser!)!, rentDay: rentDay, person: person, furniture: furniture, type: type, deposit: deposit, title: title, rentMoney: Int(rentMoney)! , additionalCost: additionalCost, data: imageData, note: notes )
            
            self.navigationController?.popViewControllerAnimated(true)
            
            
        }else {
            alert()
       }
        
        
    }

    func alert(){
        
        let alertController = UIAlertController(
            title: "警告！！！",
            message: "你必須新增照片",
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
    
    
    
}
extension SelectManViewController:  UITableViewDataSource{
    //表格的列數
    
    //設定每個section的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 100
        case 1...9:
            return 50
        default:
            return 200
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    //設定表格只有一個區段
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 11
    }
    //設定儲存格的內容
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section{
            
        case 0:
            guard let cell = myTableView.dequeueReusableCellWithIdentifier("cellHousePicture",forIndexPath: indexPath) as? HousePictureCell else{fatalError()}
            cellPicture = cell
            cell.houseImageButton.addTarget(self, action: #selector(selectPhoto(_:)), forControlEvents: .TouchUpInside)
            
            
            result = cell
        case 1:
            guard let cell = myTableView.dequeueReusableCellWithIdentifier(
                "cellTitle",forIndexPath: indexPath) as? TitleCell else{fatalError()}
            cellTitle = cell
            
            result = cell
            
        case 2:
            guard let cell = myTableView.dequeueReusableCellWithIdentifier(
                "cellRegion",forIndexPath: indexPath) as? RegionCell else{fatalError()}
            
            
            result = cell
        case 3:
            guard let cell = myTableView.dequeueReusableCellWithIdentifier (
                "cellType",forIndexPath: indexPath)as? TypeCell else{fatalError()}
            cellType = cell
            result = cell
        case 4:
            guard let cell = myTableView.dequeueReusableCellWithIdentifier(
                "cellPerson",forIndexPath: indexPath) as? PersonCell else{fatalError()}
            cellPerson = cell
            result = cell
        case 5:
            guard let cell = myTableView.dequeueReusableCellWithIdentifier(
                "cellRentDay",forIndexPath: indexPath) as? RentDayLimit else{fatalError()}
            
            cellRentDay = cell
            result = cell
            
            
        case 6:
            guard let cell = myTableView.dequeueReusableCellWithIdentifier(
                "cellDeposit",forIndexPath: indexPath) as? DepositCell else{fatalError()}
            cellDeposit = cell
            result = cell
            
        case 7:
            guard let cell = myTableView.dequeueReusableCellWithIdentifier(
                "cellMoney",forIndexPath: indexPath) as? RentMoneyCell else{fatalError()}
            cellRentMoney = cell
            
            result = cell
        case 8:
            guard let cell = myTableView.dequeueReusableCellWithIdentifier(
                "cellRentMoneyAddition",forIndexPath: indexPath) as? RentMoneyAdditionCell else{fatalError()}
            cell.rentMoneyAdditionButton.addTarget(self, action: #selector(showAdditional(_:)), forControlEvents: .TouchUpInside)
            
            cellAdditional = cell
            
            result = cell
            
            
            
        case 9:
            let sec = SelectFurnitureViewController()
            sec.delegate = self
            guard let cell = myTableView.dequeueReusableCellWithIdentifier(
                "cellFurniture",forIndexPath: indexPath) as? FurnitureCell else{fatalError()}
            cell.toFurniturebutton.addTarget(self, action: #selector(showPopOverFurniture(_:)), forControlEvents: .TouchUpInside)
            
            cellFurniture = cell
            
            
            result = cell
            
            
        default:
            guard let cell = myTableView.dequeueReusableCellWithIdentifier(
                "cellNote",forIndexPath: indexPath) as? NoteCell else{fatalError()}
            
            result = cell
            
            
        }
        
        return result
        
    }
    
    
}



//表格視圖的代理
extension SelectManViewController:  UITableViewDelegate {
    
    
    // 點選 cell 後執行的動作
    func tableView(tableView: UITableView,
                   didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 取消 cell 的選取狀態
        tableView.deselectRowAtIndexPath(
            indexPath, animated: false)
        
        
        
        
    }
    
    
}

extension SelectManViewController:  UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return .None
    }
    
    
}
var furnitureArray = [AnyObject]()
var additionalArray = [AnyObject]()
extension SelectManViewController: SecondVCDelegate{
    
    func passFurniture(value:String){
       
        furnitureArray.append(value)
        cellFurniture.furnitureLabel.text = "\(furnitureArray)"
   
    }
    
    func passAddtiionalCost(value:String){

        additionalArray.append(value)
        cellAdditional.selectAdditionalCostLabel.text = "\(additionalArray)"
        
    }
}




