//
//  Delegate.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 18..
//  Copyright © 2018년 강수진. All rights reserved.
//

import UIKit

protocol SelectDelegate {
    func tap(section : Int, selected : Any)
}

protocol SelectRowDelegate {
    func tap(row : Int, selected : Int)
}

protocol CheckDelegate {
    func check(selected : Int?)
}
