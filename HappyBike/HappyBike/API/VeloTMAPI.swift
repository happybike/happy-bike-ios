//
//  VeloTMAPI.swift
//  HappyBike
//
//  Created by Norbert Nagy on 27/05/2017.
//  Copyright © 2017 Norbert Nagy. All rights reserved.
//

import Foundation
import Alamofire

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}

class VeloTMAPI {
    func veloTMPoints(completion: @escaping ([VeloTMPOI]) -> Void) {
        Alamofire.request("http://www.velotm.ro/Station/Read", method: .post).validate().responseJSON { response in
            guard response.result.isSuccess else {
                print("velotm api error")
                completion([])
                return
            }
            
            guard let value = response.result.value as? [String : Any],
                let data = value["Data"] as? [Any] else {
                    print("velotm result value error")
                    completion([])
                    return
            }
            
            let pois = data.flatMap({ poiDict -> VeloTMPOI? in
                return VeloTMPOI(poiDict as! [String : Any])
            })
            
            completion(pois)
        }
    }
}
