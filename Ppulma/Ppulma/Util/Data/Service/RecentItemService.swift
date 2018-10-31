//
//  RecentItemService.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 11. 1..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation

struct RecentItemService : GettableService {
    typealias NetworkData = RecentItemVO
    static let shareInstance = RecentItemService()
    func getRecentList(url : String, completion : @escaping (NetworkResult<Any>) -> Void){
        get(url) { (result) in
            switch result {
            case .success(let networkResult):
                switch networkResult.resCode{
                case HttpResponseCode.getSuccess.rawValue : completion(.networkSuccess(networkResult.resResult.result))
                case HttpResponseCode.serverErr.rawValue :
                    completion(.serverErr)
                default :
                    print("no 200//500 rescode is \(networkResult.resCode)")
                    break
                }
                break
            case .error(let errMsg) :
                print(errMsg)
                break
            case .failure(_) :
                completion(.networkFail)
            }
        }
        
    }
}
