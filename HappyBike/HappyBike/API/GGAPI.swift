//
//  GGAPI.swift
//  HappyBike
//
//  Created by Norbert Nagy on 29/05/2017.
//  Copyright © 2017 Norbert Nagy. All rights reserved.
//

import UIKit
import MapKit
import Alamofire

class GGAPI {
//    static let directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=45.756779,21.216809&destination=45.757969,21.224781&sensor=false&mode=walking&key=AIzaSyDZTZ_5dTg8hZuSWE56R_XMCQ33P6Xume0"
    private static let directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false&mode=walking&key=AIzaSyDZTZ_5dTg8hZuSWE56R_XMCQ33P6Xume0"
    
    func pathBetweenCoordinate(_ first: CLLocation, second: CLLocation, completion: @escaping (String?) -> Void) {
        let url = String(format: GGAPI.directionUrl, first.coordinate.latitude, first.coordinate.longitude, second.coordinate.latitude, second.coordinate.longitude)
        Alamofire.request(url, method: .get).validate().responseJSON { (response) in
//            guard case let .failure(error) = response.result else { return }
//            if let error = error as? AFError {
//                print(error.localizedDescription)
//            } else if error is URLError {
//                print("URL error")
//            } else {
//                print("Unknown error")
//            }
            
            guard response.result.isSuccess else {
                completion(nil)
                return
            }
            
            guard let value = response.result.value as? [String: Any] else {
                completion(nil)
                return
            }
            
            guard let routes = value["routes"] as? [Any],
                routes.count > 0,
                let route = routes[0] as? [String: Any],
                let overviewPolylines = route["overview_polyline"] as? [String: Any],
                let points = overviewPolylines["points"] as? String else {
                    print("gg direction parse error")
                    completion(nil)
                    return
            }
            
            completion(points) // return encoded path that can be used to create a path on map
        }
    }
}
