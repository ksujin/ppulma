//
//  CartVO.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 31..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation
struct CartVO: Codable {
    let message: String
    let result: [CartVOResult]
}

struct CartVOResult: Codable {
    let cartIdx, productIdx, productName: String
    let productImg: String
    let productPrice, productCount: Int
    
    enum CodingKeys: String, CodingKey {
        case cartIdx = "cart_idx"
        case productIdx = "product_idx"
        case productName = "product_name"
        case productImg = "product_img"
        case productPrice = "product_price"
        case productCount = "product_count"
    }
}
