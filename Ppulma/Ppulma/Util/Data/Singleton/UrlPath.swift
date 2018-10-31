//
//  UrlPath.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 29..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation

enum UrlPath : String {
    //로그인
    case category = "/category/"
    case semiCategory = "/semi/"
    case semiCategoryOrderByPrice = "/semi/price/"
    case product = "/product/"
    case cart = "/cart/"
    case search = "/search?keyword="

    func getURL(_ parameter : String? = nil) -> String{
        return "\(NetworkConfiguration.shared().baseURL)\(self.rawValue)\(parameter ?? "")"
    }
}
