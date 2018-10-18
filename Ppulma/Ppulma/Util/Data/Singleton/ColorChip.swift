//
//  ColorChip.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 17..
//  Copyright © 2018년 강수진. All rights reserved.
//


import UIKit

class ColorChip {
    
    let mainPurple = #colorLiteral(red: 0.262745098, green: 0.2274509804, blue: 0.6705882353, alpha: 1)
    let mainOrange = #colorLiteral(red: 1, green: 0.7058823529, blue: 0, alpha: 1)
    let barbuttonColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
    
    struct StaticInstance {
        static var instance: ColorChip?
    }
    
    class func shared() -> ColorChip {
        if StaticInstance.instance == nil {
            StaticInstance.instance = ColorChip()
        }
        return StaticInstance.instance!
    }
}
