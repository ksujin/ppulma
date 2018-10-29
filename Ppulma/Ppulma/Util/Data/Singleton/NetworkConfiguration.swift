//
//  NetworkConfiguration.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 29..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation
class NetworkConfiguration {
    let baseURL = "http://mjee.ml:3000/api"
    
    struct StaticInstance {
        static var instance: NetworkConfiguration?
    }
    
    class func shared() -> NetworkConfiguration {
        if StaticInstance.instance == nil {
            StaticInstance.instance = NetworkConfiguration()
        }
        return StaticInstance.instance!
    }
}
