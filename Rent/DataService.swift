//
//  DataService.swift
//  Renter
//
//  Created by apple on 2016/9/23.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import Foundation
import Firebase
import FBSDKLoginKit
import MBProgressHUD


protocol FirebaseDelegate: class {
    func manager(manager: DataService, didGetStationsData: AnyObject)
    
}


let rootRef = FIRDatabase.database().reference()
class DataService{
    
    weak var delegate: FirebaseDelegate?
    
    static let dataService = DataService()
    
    private var _BASE_REF = rootRef
    
    private var _POST_REF = rootRef.child("posts")
    private var _MESSAGE_REF = rootRef.child("messages")
    private var _PEOPLE_REF = rootRef.child("user")
    private var _PARTICIPANTS_REF = rootRef.child("participants")
    
    
    
    var currentUser: FIRUser? {
        return FIRAuth.auth()?.currentUser!
    }
    
    var PARTICIPANTS_REF: FIRDatabaseReference{
        return _PARTICIPANTS_REF
    }
    
    var BASE_REF: FIRDatabaseReference{
        return _BASE_REF
    }
    var PEOPLE_REF: FIRDatabaseReference{
        return _PEOPLE_REF
    }
    
    var MESSAGE_REF: FIRDatabaseReference{
        return _MESSAGE_REF
    }
    var POST_REF: FIRDatabaseReference{
        return _POST_REF
    }
    
    var storageRef: FIRStorageReference{
        return FIRStorage.storage().reference()
    }
    
    
    var fileUrl: String!
    
    
    //save profile
    func SaveProfile(username: String, email: String, data: NSData){
        let user = FIRAuth.auth()?.currentUser
        let filePath = "\(user?.uid)/\(NSDate.timeIntervalSinceReferenceDate())"
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpg"
        self.storageRef.child(filePath).putData(data, metadata: metaData){
            (metaData, error) in
            
            if let error = error{
                
                print(error.description)
                return
            }
            self.fileUrl = metaData?.downloadURLs![0].absoluteString
            let changeRequestProfile = user?.profileChangeRequest()
            changeRequestProfile?.photoURL = NSURL(string: self.fileUrl)
            changeRequestProfile?.displayName = username
            changeRequestProfile?.commitChangesWithCompletion({ (error) in
                if let error = error{
                    print(error.localizedDescription)
                    // ProgressHUD.showError("network error")
                }else{
                    print("profile updated")
                }
            })
            
            self.PEOPLE_REF.child((user?.uid)!).setValue(["username": username, "email": email, "profileImage": self.storageRef.child((metaData?.path)!).description])
            
            
            
            if let user = user {
                user.updateEmail(email, completion: { (error) in
                    if let error = error{
                        print(error.description)
                    }else{
                        print("email update")
                        
                        
                    }
                })
            }
        }
        
    }
    
    func CreatePostData(user: FIRUser, rentDay: String, person: String, furniture: String,type: String, deposit:String, title: String, rentMoney: Int, additionalCost: String, data: NSData, note: String){
        let filePath = "\(user.uid)/\(Int(NSDate.timeIntervalSinceReferenceDate()))"
        
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpg"
        storageRef.child(filePath).putData(data, metadata: metaData){(metaData, error) in
            if let error = error{
                print(error.description)
                return
            }
            
            
            let newFileUrl = metaData!.downloadURLs![0].absoluteString
            if let user = FIRAuth.auth()?.currentUser{
                let idRoom = self.POST_REF.childByAutoId()
                idRoom.setValue(["rentDay": rentDay, "person": person, "furniture": furniture, "type": type, "deposit": deposit, "title": title, "rentMoney": rentMoney, "additionalCost": additionalCost, "image": self.storageRef.child(metaData!.path!).description, "fuleUrl": newFileUrl, "user": user.uid, "note": note])
                self.PEOPLE_REF.child(user.uid).child("myPostRooms").child(idRoom.key).setValue(true)
            }
        }
        
    }
    
    
    //register email password
    func SignUp(username: String, email: String, password: String, data: NSData){
        
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: {(user, error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            let changeRequest = user?.profileChangeRequest()
            changeRequest?.displayName = username
            changeRequest?.commitChangesWithCompletion({ (error) in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
            })
            
            let filePath = "profileImage/\(user?.uid)"
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            self.storageRef.child(filePath).putData(data, metadata:  metadata, completion: {(metadata,error) in
                if let error = error{
                    print(error.description)
                    return
                }
                
                
                self.fileUrl = metadata?.downloadURLs![0].absoluteString
                let changeRequestPhoto = user?.profileChangeRequest()
                changeRequestPhoto?.photoURL = NSURL(string: self.fileUrl)
                changeRequestPhoto?.commitChangesWithCompletion({ (error) in
                    if let error = error{
                        print(error.localizedDescription)
                        return
                    }else{
                        print("profileupdate")
                    }
self.PEOPLE_REF.child((user?.uid)!).setValue(["username": username, "email": email, "profileImage": self.storageRef.child((metadata?.path)!).description])
                    
                    
                })
                
                
            })
        })
        
    }
    
    func saveFbData(email: String, name: String, data: NSData){
        
        let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
        FIRAuth.auth()?.signInWithCredential(credential, completion:  { (user, error) in
            
            
            let filePath = "profileImage/\(user?.uid)"
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            self.storageRef.child(filePath).putData(data, metadata:  metadata, completion: {(metadata,error) in
                if let error = error{
                    print(error.description)
                    return
                }
                self.fileUrl = metadata?.downloadURLs![0].absoluteString
                let changeRequestPhoto = user?.profileChangeRequest()
                changeRequestPhoto?.photoURL = NSURL(string: self.fileUrl)
                changeRequestPhoto?.commitChangesWithCompletion({ (error) in
                    if let error = error{
                        print(error.localizedDescription)
                        return
                    }else{
                        print("profileupdate")
                    }
                    self.PEOPLE_REF.child((user?.uid)!).setValue(["username": name , "email": email, "profileImage": self.storageRef.child((metadata?.path)!).description])
                    
                    
                })
            })
            
            
            
        })
    }
    
    func logout(){
        let firebaseAuth = FIRAuth.auth()
        do{
            try firebaseAuth?.signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewControllerWithIdentifier("Login")
            UIApplication.sharedApplication().keyWindow?.rootViewController = loginVC
        }catch let signOutError as NSError{
            print(signOutError)
            
        }
    }
    func login(email: String, password: String){
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            print("successfully")
            //successfully logged in our user
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.login()
            
            
        })
        
        
    }
    var postDictionary = [String: PostData]()
    func fetchMyPostRoom(callback:(PostData)->()){
        
        let user = currentUser?.uid
        
        DataService.dataService.PEOPLE_REF.queryOrderedByKey().queryEqualToValue(user).observeEventType(.Value, withBlock:  { (snap) in
            
            guard let dictionary = snap.value as? Dictionary<String,AnyObject> else{return}
            
            for (_, value) in dictionary {
                guard  let roomKeys = value["myPostRooms"] as? Dictionary<String,AnyObject> else{return}
                for (key,_) in roomKeys{
                    
                    DataService.dataService.POST_REF.queryOrderedByKey().queryEqualToValue(key).observeEventType(.ChildAdded, withBlock: { (snappost) in
                        
                        let post = PostData(key: snappost.key, snapshot: snappost.value as! Dictionary<String, AnyObject>)
                        callback(post)
                    })
                }
            }
            
            
        })

        
        
        
    }
    
    
    
    
    func fetchPostData(callback:(PostData)->()){
        
        DataService.dataService.POST_REF.observeEventType(.ChildAdded, withBlock:  { (snapshot) in
            let post = PostData(key: snapshot.key, snapshot: snapshot.value as! Dictionary<String, AnyObject>)
            
            callback(post)
        })
        
    }
    func CreateNewMessage(userId: String, roomId: String, textMessage: String, date: NSNumber){
        
        guard  let participantUser = currentUser?.uid else{return}
        let idMessage = rootRef.child("messages").childByAutoId()
        DataService.dataService.MESSAGE_REF.child(idMessage.key).setValue(["message": textMessage, "senderId": userId, "date": date,"roomId": roomId])
        DataService.dataService.POST_REF.child(roomId).child("lastMessage").setValue(idMessage.key)
        
        DataService.dataService.PARTICIPANTS_REF.child(roomId).updateChildValues([participantUser: true])
        
        
        
    }
    
    func fetechMessage(roomId: String, callback: (FIRDataSnapshot) ->()){
        
        DataService.dataService.POST_REF.child(roomId).observeEventType(.Value, withBlock: {(snapshot)in
            
            DataService.dataService.MESSAGE_REF.child("roomId").child(snapshot.key).observeEventType(.ChildAdded, withBlock: {(snap)in
                callback(snap)
                
                
            })
        })
    }
    func fetechUserMessage(callback:(FIRDataSnapshot)->()){
        
        
        guard let currentUser = DataService.dataService.currentUser?.uid else{return}
        
        DataService.dataService.PARTICIPANTS_REF.queryOrderedByChild(currentUser).queryEqualToValue(true).observeEventType(.Value, withBlock:{ (snapshot) in
            
            guard let dictionary = snapshot.value as? Dictionary<String,AnyObject> else { return }
            print(dictionary)
            let keys = Array(dictionary.keys)
            for roomId in keys{
                
                
                DataService.dataService.POST_REF.queryOrderedByKey().queryEqualToValue(roomId).observeEventType(.Value, withBlock: { (snap) in
                    for child in snap.children {
                        
                        if let last = child.value["lastMessage"] as? String {
                            print(last)
                            DataService.dataService.MESSAGE_REF.queryOrderedByKey().queryEqualToValue(last).observeEventType(.ChildAdded, withBlock: { (messagesnap) in
                                
                                
                                
                                callback(messagesnap)
                                
                            })
                        }
                    }
                })
            }
        })
        
        
        
        
        
        
        
        
        
    }
    
    
    
}
