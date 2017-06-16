//
//  Model.swift
//  ToDoList
//
//  Created by liuxu on 2017/6/13.
//  Copyright © 2017年 liuxu. All rights reserved.
//

import UIKit

//public enum modelStatus {
//    case Todo, Complete
//}

class Model: NSObject {
    var title: String?
    var status: Int?
//    var height: CGFloat {
//        get {
//            let hei: CGFloat = (self.title?.boundingRect(with: CGSize.init(width: SCREEN_WIDTH - 40 - 70, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 15)], context: nil).height)!
//            return hei < 40 ? 40 : hei
//        }
//    }
    
    var Id: Int?
}
