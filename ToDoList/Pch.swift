//
//  Pch.swift
//  ToDoList
//
//  Created by liuxu on 2017/6/13.
//  Copyright © 2017年 liuxu. All rights reserved.
//

import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let MENU_HEIGHT: CGFloat = 60
let LINE_HEIGHT: CGFloat = 1
let STATUSBAR_HEIGHT: CGFloat = 20

let TOPVIEW_HEIGHT = STATUSBAR_HEIGHT + MENU_HEIGHT
let SCROLLVIEW_HEIGHT = SCREEN_HEIGHT - TOPVIEW_HEIGHT

func UIColorFromRGB(_ rgbValue: Int) -> (UIColor) {
    return UIColor.init(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0, green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0, blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0, alpha: 1.0)
}

func UIColorFromRGBA(_ rgbValue: Int, _ alpha: CGFloat) -> (UIColor) {
    return UIColor.init(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0, green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0, blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0, alpha: alpha)
}

let BACKGROUND_COLOR = UIColorFromRGB(0x4cc7fc)

class Pch: NSObject {

}
