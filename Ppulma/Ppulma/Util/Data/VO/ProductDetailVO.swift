//
//  ProductDetailVO.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 31..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation
struct ProductDetailVO: Codable {
    let message: String
    let result: [ProductDetailVOResult]
}

struct ProductDetailVOResult: Codable {
    let name: String
    let price: Int
    let imgURL, detailURL: String
    
    enum CodingKeys: String, CodingKey {
        case name, price
        case imgURL = "img_url"
        case detailURL = "detail_url"
    }
}
