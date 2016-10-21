//
//  RegisterController.swift
//  Renter
//
//  Created by apple on 2016/9/27.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit
import Firebase

class RegisterController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
   
    func handleRegister(){
        guard let email = emailField.text, password = passwordField.text, name = usernameField.text else{
            print("Form is not valid")
            return
        }
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user: FIRUser?, error)in
            if error != nil{
                print(error)
                return
            }
            
            guard let uid = user?.uid else{return}
            
            
            let ref = FIRDatabase.database().referenceFromURL("https://test-a486f.firebaseio.com/")
            let userReference = ref.child("users").child(uid)
            let values = ["name": name, "email": email]
            userReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if err != nil{
                    print(err)
                    return
                }
                print("Saved user successfully into Firebase db")
            })
        })
    }


}
