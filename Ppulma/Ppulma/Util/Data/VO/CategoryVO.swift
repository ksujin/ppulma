//
//  MagazineVO.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 29..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation

struct CategoryVO: Codable {
    let message: String
    let result: [CategoryVOResult]
    let semiResult: [CategoryVOSemiResult]
    
    enum CodingKeys: String, CodingKey {
        case message, result
        case semiResult = "semi_result"
    }
}

struct CategoryVOResult: Codable {
    let title: String
    let imgURL: String
    let hash, content: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case imgURL = "img_url"
        case hash, content
    }
}

struct CategoryVOSemiResult: Codable {
    let semiCategoryIdx, semiTitle: String
    let semiImgURL: [String]
    
    enum CodingKeys: String, CodingKey {
        case semiCategoryIdx = "semiCategory_idx"
        case semiTitle = "semi_title"
        case semiImgURL = "semi_img_url"
    }
}
