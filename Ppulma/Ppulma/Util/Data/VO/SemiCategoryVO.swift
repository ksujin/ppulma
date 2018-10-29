//
//  SemiCategoryVO.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 29..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation
struct SemiCategoryVO: Codable {
    let message: String
    let result: [SemiCategoryVOResult]
}

struct SemiCategoryVOResult: Codable {
    let productIdx, productName: String
    let productPrice: Int
    let productImgURL: String
    
    enum CodingKeys: String, CodingKey {
        case productIdx = "product_idx"
        case productName = "product_name"
        case productPrice = "product_price"
        case productImgURL = "product_img_url"
    }
}

