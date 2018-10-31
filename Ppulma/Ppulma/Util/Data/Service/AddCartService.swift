//
//  AddCartService.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 31..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation
struct AddCartService: PostableService, GettableService {
    
    typealias NetworkData = MessageVO
    static let shareInstance = AddCartService()
    func addCart(url : String, params : [String : Any], completion : @escaping (NetworkResult<Any>) -> Void){
        post(url, params: params) { (result) in
            switch result {
            case .success(let networkResult):
                switch networkResult.resCode{
                case HttpResponseCode.postSuccess.rawValue :
                    completion(.networkSuccess(networkResult.resResult.message))
                case HttpResponseCode.serverErr.rawValue :
                    completion(.serverErr)
                default :
                    print("no 201/500 rescode is \(networkResult.resCode)")
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
    
    func deleteCart(url : String, params : [String : Any] = [:], completion : @escaping (NetworkResult<Any>) -> Void){
        get(url, method: .delete, parameters: params) { (result) in
            switch result {
            case .success(let networkResult):
                switch networkResult.resCode{
                case HttpResponseCode.getSuccess.rawValue : completion(.networkSuccess(networkResult.resResult.message))
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
    
    func updateCart(url : String, params : [String : Any], completion : @escaping (NetworkResult<Any>) -> Void){
        post(url, params: params, method: .put) { (result) in
            switch result {
            case .success(let networkResult):
                switch networkResult.resCode{
                case HttpResponseCode.getSuccess.rawValue :
                    completion(.networkSuccess(networkResult.resResult.message))
                case HttpResponseCode.serverErr.rawValue :
                    completion(.serverErr)
                default :
                    print("no 200/500 rescode is \(networkResult.resCode)")
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
