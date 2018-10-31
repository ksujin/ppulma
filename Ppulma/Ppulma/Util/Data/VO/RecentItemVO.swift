//
//  RecentItemVO.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 11. 1..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation
struct RecentItemVO: Codable {
    let message: String
    let result: [RecentItemVOResult]
}

struct RecentItemVOResult: Codable {
    let productIdx: String
    let imgURL: [String]
    
    enum CodingKeys: String, CodingKey {
        case productIdx = "product_idx"
        case imgURL = "img_url"
    }
}
