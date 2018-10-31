//
//  GettableService.swift
//  Ppulma
//
//  Created by 강수진 on 2018. 10. 29..
//  Copyright © 2018년 강수진. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct CustomGetEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try URLEncoding().encode(urlRequest, with: parameters)
        request.url = URL(string: request.url!.absoluteString.replacingOccurrences(of: "%5B%5D=", with: "="))
        return request
    }
}


// Remove square brackets for POST request
struct CustomPostEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        //원래 method가 .post 라면 URLEncoding().encode해도 되지만 .delete 이기때문에 httpBody 없어서 터짐. 그래서 url과 파라미터를 이용해 URLEncoding.httpBody 방식으로 인코딩해서 httpBody 뽑아낸 후에 [] 없앰
        var request = try URLEncoding.httpBody.encode(urlRequest, with: parameters)
        let httpBody = NSString(data: request.httpBody!, encoding: String.Encoding.utf8.rawValue)!
        request.httpBody = httpBody.replacingOccurrences(of: "%5B%5D=", with: "=").data(using: .utf8)
        return request
    }
}

protocol GettableService {
    associatedtype NetworkData : Codable
    typealias networkResult = (resCode : Int, resResult : NetworkData)
    func get(_ URL:String, method : HTTPMethod,  parameters : [String: Any], completion : @escaping (Result<networkResult>)->Void)
    
}

extension GettableService {
    
    func gino(_ value : Int?) -> Int {
        return value ?? 0
    }
    
    func get(_ URL:String, method : HTTPMethod = .get, parameters : [String: Any] = [:],  completion : @escaping (Result<networkResult>)->Void){
        guard let encodedUrl = URL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("networking - invalid url")
            return
        }
        
        print("url 은 \(encodedUrl)")
        
        let userToken = UserDefaults.standard.string(forKey: "userToken") ?? "-1"
        var headers: HTTPHeaders?
        
        if userToken != "-1" {
            headers = [
                "authorization" : userToken
            ]
        }

      
        Alamofire.request(encodedUrl, method: method, parameters: parameters, encoding : CustomPostEncoding(),headers: headers).responseData {(res) in
            print("encodedURK")
            print(encodedUrl)
            switch res.result {
                
            case .success :
                if let value = res.result.value {
                    print("networking Get Here!")
                    print(encodedUrl)
                    print(JSON(value))
                    
                    let decoder = JSONDecoder()
                    do {
                        let resCode = self.gino(res.response?.statusCode)
                        let data = try decoder.decode(NetworkData.self, from: value)
                        
                        let result : networkResult = (resCode, data)
                        completion(.success(result))
                        
                    }catch{
                        completion(.error("error get"))
                    }
                }
                break
            case .failure(let err) :
                print(err.localizedDescription)
                completion(.failure(err))
                break
            }
            
        }
    }
    
}
