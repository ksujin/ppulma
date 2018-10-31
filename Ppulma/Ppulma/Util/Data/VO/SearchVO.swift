//
//  SearchVO.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 11. 1..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation

struct SearchVO: Codable {
    let message: String
    let result: [SearchVOResult]
}

struct SearchVOResult: Codable {
    let productIdx, name: String
    let price: Int
    let imgURL: String
    
    enum CodingKeys: String, CodingKey {
        case productIdx = "product_idx"
        case name, price
        case imgURL = "img_url"
    }
}
