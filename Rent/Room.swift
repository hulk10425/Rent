//
//  Room.swift
//  Renter
//
//  Created by apple on 2016/10/7.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import Foundation
import UIKit
import Firebase




class PostData{

    var rentDay: String!
    var furniture: String!
    var deposit: String!
    var additionalCost: String!
    var region: String!
    var note: String!
    var title: String!
    var person: String!
    var rentMoney: Int!
    var imageUrl: String!
    var type: String!
    var user: String!
    var id : String!
    
    

    init(key: String, snapshot:Dictionary<String,AnyObject>){
        self.id = key
        self.type = snapshot["type"] as? String
        self.title = snapshot["title"] as? String
         self.person = snapshot["person"] as? String
         self.rentMoney = snapshot["rentMoney"] as? Int
         self.imageUrl = snapshot["image"] as? String
        self.region = snapshot["region"] as? String
        self.user = snapshot["user"] as? String
        self.rentDay = snapshot["rentDay"] as? String
        self.furniture = snapshot["furniture"] as? String
        self.deposit = snapshot["deposit"] as? String
         self.additionalCost = snapshot["additionalCost"] as? String
        self.note = snapshot["note"] as? String

        
    }

}

class PostDataValue{
    
    var rentDay: String!
    var furniture: String!
    var deposit: String!
    var additionalCost: String!
    var region: String!
    var note: String!
    var title: String!
    var person: String!
    var rentMoney: Int!
    var imageUrl: String!
    var type: String!
    var user: String!
    
    
    
    
    init(snapshot:Dictionary<String,AnyObject>){
       
        self.type = snapshot["type"] as? String
        self.title = snapshot["title"] as? String
        self.person = snapshot["person"] as? String
        self.rentMoney = snapshot["rentMoney"] as? Int
        self.imageUrl = snapshot["image"] as? String
        self.region = snapshot["region"] as? String
        self.user = snapshot["user"] as? String
        self.rentDay = snapshot["rentDay"] as? String
        self.furniture = snapshot["furniture"] as? String
        self.deposit = snapshot["deposit"] as? String
        self.additionalCost = snapshot["additionalCost"] as? String
        self.note = snapshot["note"] as? String
        
        
    }
    
}
class Chats: NSObject{
    var senderId: String!
    var message: String!
    var date: NSNumber!
    var roomId: String!
    
    
}
class User: NSObject{
    var email: String!
    var profileImage: String!
    var username: String!
    var id: String!
}
class Order{
   
    var rentDay: String!
    var furniture: String!
    var deposit: String!
    var additionalCost: String!
    var region: String!
    var note: String!
    var title: String!
    var person: String!
    var rentMoney: Int!
    var imageUrl: String!
    var type: String!


}

