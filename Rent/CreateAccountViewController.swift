//
//  CreateAccountViewController.swift
//  Renter
//
//  Created by apple on 2016/9/23.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import MBProgressHUD

class CreateAccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    var myUserDefaluts: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    
    @IBOutlet var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        //        UIImage(named: "background2")?.drawInRect(self.view.bounds)
        
        //        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        //        UIGraphicsEndImageContext()
        //        backgroundView.backgroundColor = UIColor(patternImage: image)
        backgroundView.backgroundColor = UIColor.whiteColor()
        
        let blurEffect = UIBlurEffect(style: .Light)
        
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.alpha = 1
        blurView.frame = backgroundView.bounds
        backgroundView.addSubview(blurView)
        
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(loginFbButton)
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
        setupFbLoginButton()
        passwordTextField.delegate = self
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //收起键盘
        textField.resignFirstResponder()
        passwordTextField.text = textField.text
        
        return true
    }
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor(r: 255, g: 92, b: 25).CGColor
        view.layer.masksToBounds = true
        view.layer.borderWidth = 2
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .System)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(r: 255, g: 92, b: 25).CGColor
     
        button.setTitle("註冊", forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(r: 255, g: 92, b: 25), forState: .Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(handleLoginRegister), forControlEvents: .TouchUpInside)
        
        
        return button
    }()
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.secureTextEntry = true
        
        
        
        return tf
    }()
    

    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profileImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //imageView.contentMode = .ScaleAspectFill
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.userInteractionEnabled = true
        
        
        
        return imageView
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["登入", "註冊"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.blackColor()
        sc.selectedSegmentIndex = 1
        sc.layer.borderWidth = 2
        sc.layer.cornerRadius = 8
        sc.tintColor = UIColor(r: 255, g: 92, b: 25)
        
        sc.layer.borderColor = UIColor(r: 255, g: 92, b: 25).CGColor
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), forControlEvents: .ValueChanged)
        return sc
    }()
    lazy var loginFbButton: UIButton = {
        let button = UIButton(type: .System)
        //button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Facebook 登入", forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(r: 80, g: 101, b: 161), forState: .Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(r: 80, g: 101, b: 161).CGColor
        
        
        button.addTarget(self, action: #selector(handleFbLogin), forControlEvents: .TouchUpInside)
        
        
        return button
    }()
    
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
            profileImageView.layer.cornerRadius =  profileImageView.frame.size.height/2
            profileImageView.clipsToBounds = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    func handleFbLogin(){
      
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logInWithReadPermissions(["email","public_profile"], fromViewController: self) { (result, error) -> Void in
            
         if (error == nil){
          
            let fbloginresult : FBSDKLoginManagerLoginResult = result
        if(fbloginresult.grantedPermissions.contains("email")){
                   
                self.getFBUserData()
        }else{
          return
        }
    }
}
}
    
    func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            let parameters = ["fields": "name, picture.type(large), email, link"]
            FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler{ (connection, result, error) -> Void in
                if (error != nil){
                    print(error)
                    return
                }
                
                guard let fbname = result["name"] as? String else{return}
                guard let fbemail = result["email"] as? String else{return}
                
                
//                self.myUserDefaluts.setObject(result["name"], forKey: "FBname")
//                self.myUserDefaluts.setObject(result["email"], forKey: "FBemail")
                guard
                    let picture = result["picture"] as? NSDictionary,
                    let picData = picture["data"] as? NSDictionary,
                    let modifiedUrlStr = picData["url"] as? String,
                    let url = NSURL(string: modifiedUrlStr),
                    let data = NSData(contentsOfURL: url) else{return}
                let fbImage = data
//                self.myUserDefaluts.setObject(Image, forKey: "FBimage")
//                self.myUserDefaluts.synchronize()
//                
//                guard let fbname = self.myUserDefaluts.objectForKey("FBname")  as? String else{return}
//                guard let fbemail = self.myUserDefaluts.objectForKey("FBemail") as? String else{return}
//                guard  let fbImage = self.myUserDefaluts.objectForKey("FBimage")  as? NSData else{return}
                let refreshedToken = FIRInstanceID.instanceID().token()
////
//                self.myUserDefaluts.removeObjectForKey("FBname")
//                   self.myUserDefaluts.removeObjectForKey("FBemail")
//                   self.myUserDefaluts.removeObjectForKey("FBImage")
                DataService.dataService.saveFbData(fbemail, name: fbname, data: fbImage, token: refreshedToken!)

            }
        }
        
        
    }
    
    
    
    func handleLogin() {
        guard let email = emailTextField.text where !email.isEmpty, let password = passwordTextField.text where !password.isEmpty else {
            print("Form is not valid")
            alert()
            return
        }
        
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            if let error = error{
                print(error.localizedDescription)
                self.alert()
                return
            }
            print("successfully")
            //successfully logged in our user
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)

            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.login()
            
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            
            
        })
    }
    
    func alert(){
        let alertController = UIAlertController(
            title: "警告！！！",
            message: "無效的格式",
            preferredStyle: .Alert)
        
     
        // 建立[送出]按鈕
        let okAction = UIAlertAction(
            title: "確定",
            style: .Default,
            handler: nil)
        alertController.addAction(okAction)
        
        // 顯示提示框
        self.presentViewController(alertController,animated: true, completion: nil)
        
        
        
    }

    
    func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegmentAtIndex(loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, forState: .Normal)
        
        // change height of inputContainerView, but how???
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        
        // change height of nameTextField
        nameTextFieldHeightAnchor?.active = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.active = true
        
        emailTextFieldHeightAnchor?.active = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.active = true
        
        passwordTextFieldHeightAnchor?.active = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.active = true
    }
    
    
    
    func handleRegister() {
        guard let email = emailTextField.text where !email.isEmpty , let password = passwordTextField.text where !password.isEmpty , let name = nameTextField.text where !name.isEmpty else {
            print("Form is not valid")
            alert()
            return
        }
    
        
        let refreshedToken = FIRInstanceID.instanceID().token()
        
        
        
        var data = NSData()
        data = UIImageJPEGRepresentation(profileImageView.image!, 0.1)!
   
//        showtips(self.view)
      
//                MBProgressHUD.hideHUDForView(view, animated: false)
                let HUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                view.addSubview(HUD)
                HUD.label.text = "註冊成功"
                HUD.mode = MBProgressHUDMode.CustomView
                HUD.customView = UIImageView(image: UIImage(named: "success")) //这是一个对勾的图标
                HUD.userInteractionEnabled = false
                HUD.minShowTime = 2
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)){
                 
                DataService.dataService.SignUp(name, email: email, password: password, data: data, token: refreshedToken!)
                    
                    dispatch_async(dispatch_get_main_queue()){
                 
                      
                    HUD.hideAnimated(true)
                    }
                }
        
    }
//    func showtips(view:UIView){
//        MBProgressHUD.hideHUDForView(view, animated: false)
//        let HUD = MBProgressHUD(view:view)
//        view.addSubview(HUD)
//        HUD.label.text = "註冊成功"
//        HUD.mode = MBProgressHUDMode.CustomView
//        HUD.customView = UIImageView(image: UIImage(named: "success")) //这是一个对勾的图标
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)){
//          HUD.showAnimated(true)
//            dispatch_async(dispatch_get_main_queue()){
//                
//            HUD.hideAnimated(true)
//            }
//        }
//
//       
//    }
    func setupLoginRegisterSegmentedControl() {
        //need x, y, width, height constraints
        loginRegisterSegmentedControl.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        loginRegisterSegmentedControl.bottomAnchor.constraintEqualToAnchor(inputsContainerView.topAnchor, constant: -12).active = true
        loginRegisterSegmentedControl.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor, multiplier: 1).active = true
        loginRegisterSegmentedControl.heightAnchor.constraintEqualToConstant(36).active = true
    }
    
    func setupFbLoginButton(){
        
        loginFbButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        loginFbButton.bottomAnchor.constraintEqualToAnchor(loginRegisterButton.bottomAnchor, constant: 72).active = true
        loginFbButton.widthAnchor.constraintEqualToAnchor(loginRegisterButton.widthAnchor, multiplier: 1).active = true
        loginFbButton.heightAnchor.constraintEqualToConstant(48).active = true
    }
    
    
    func setupProfileImageView() {
        //need x, y, width, height constraints
        profileImageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
     
        profileImageView.bottomAnchor.constraintEqualToAnchor(inputsContainerView.topAnchor, constant: -72).active = true
        profileImageView.widthAnchor.constraintEqualToConstant(150).active = true
        profileImageView.heightAnchor.constraintEqualToConstant(150).active = true
    }
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setupInputsContainerView() {
        //need x, y, width, height constraints
        inputsContainerView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        inputsContainerView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        inputsContainerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -24).active = true
        
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraintEqualToConstant(150)
        inputsContainerViewHeightAnchor?.active = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        //need x, y, width, height constraints
        nameTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
        nameTextField.topAnchor.constraintEqualToAnchor(inputsContainerView.topAnchor).active = true
        
        nameTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        
        
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.active = true
        
        //need x, y, width, height constraints
        nameSeparatorView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor).active = true
        nameSeparatorView.topAnchor.constraintEqualToAnchor(nameTextField.bottomAnchor).active = true
        nameSeparatorView.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        nameSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
        
        //need x, y, width, height constraints
        emailTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
        emailTextField.topAnchor.constraintEqualToAnchor(nameTextField.bottomAnchor).active = true
        
        emailTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        
        
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.active = true
        
        //need x, y, width, height constraints
        emailSeparatorView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor).active = true
        emailSeparatorView.topAnchor.constraintEqualToAnchor(emailTextField.bottomAnchor).active = true
        emailSeparatorView.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        emailSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
        
        //need x, y, width, height constraints
        passwordTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
        passwordTextField.topAnchor.constraintEqualToAnchor(emailTextField.bottomAnchor).active = true
        
        passwordTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.active = true
    }
    
    func setupLoginRegisterButton() {
        //need x, y, width, height constraints
        loginRegisterButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        loginRegisterButton.topAnchor.constraintEqualToAnchor(inputsContainerView.bottomAnchor, constant: 12).active = true
        loginRegisterButton.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        loginRegisterButton.heightAnchor.constraintEqualToConstant(50).active = true
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}
