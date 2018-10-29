//
//  MagazineService.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 29..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation

struct MagazineService : GettableService {
    typealias NetworkData = CategoryVO
    static let shareInstance = MagazineService()
    func getMagazineData(url : String, completion : @escaping (NetworkResult<Any>) -> Void){
        get(url) { (result) in
            switch result {
            case .success(let networkResult):
                switch networkResult.resCode{
                case HttpResponseCode.getSuccess.rawValue : completion(.networkSuccess(networkResult.resResult.semiResult))
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
