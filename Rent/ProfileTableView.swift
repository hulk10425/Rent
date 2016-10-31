//
//  ProfileTableView.swift
//  Renter
//
//  Created by apple on 2016/10/12.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//


import UIKit
import Firebase
import Kingfisher


class ProfileTableView: UIViewController{

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBAction func backSettingButton(sender: AnyObject) {
          self.navigationController?.popViewControllerAnimated(true)
    }
   
    @IBOutlet weak var profileView: UIView!

    @IBOutlet weak var username: UILabel!


    @IBOutlet weak var email: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "個人資料"
        //let tap = UITapGestureRecognizer(target: self, action: #selector(ProfileTableView.selectPhoto(_:)))
        
       // tap.numberOfTapsRequired = 1
       // profileImage.addGestureRecognizer(tap)
        
        profileView.layer.cornerRadius = profileView.frame.height/2
        profileView.clipsToBounds = true
        profileView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        
        
        
        
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.clipsToBounds = true
        profileImage.layer.borderWidth = 1
        if let user = DataService.dataService.currentUser{
        username.text = user.displayName
            email.text = user.email
            if user.photoURL != nil{
                self.profileImage.kf_setImageWithURL(user.photoURL)
            }
        }else{
        
        }
    }
    
    
//    func selectPhoto(tap: UITapGestureRecognizer){
//    let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        imagePicker.allowsEditing = true
//        if UIImagePickerController.isSourceTypeAvailable(.Camera){
//        imagePicker.sourceType = .Camera
//        }else{
//        imagePicker.sourceType = .PhotoLibrary
//        }
//        self.presentViewController(imagePicker, animated: true, completion: nil)
//    }
//    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
//        profileImage.image = image
//        dismissViewControllerAnimated(true, completion: nil)
//    }
//    @IBAction func saveDidTapped(sender: AnyObject) {
//        
//        var data = NSData()
//        data = UIImageJPEGRepresentation(profileImage.image!, 0.1)!
//        DataService.dataService.SaveProfile(username.text!, email: email.text! , data: data)
//        
//    }
//   override func tableView(tableView: UITableView,
//                   didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        // 取消 cell 的選取狀態
//        tableView.deselectRowAtIndexPath(
//            indexPath, animated: false)
//        
//    }
//    

}