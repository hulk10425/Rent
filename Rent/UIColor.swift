//
//  UIColor.swift
//  Renter
//
//  Created by apple on 2016/9/26.
//  Copyright © 2016年 Johnny Demo. All rights reserved.
//

import UIKit
extension UIColor{

    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
