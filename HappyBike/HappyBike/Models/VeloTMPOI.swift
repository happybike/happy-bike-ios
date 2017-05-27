//
//  VeloTMPOI.swift
//  HappyBike
//
//  Created by Norbert Nagy on 27/05/2017.
//  Copyright © 2017 Norbert Nagy. All rights reserved.
//

import Foundation
import MapKit

struct VeloTMPOI {
    var stationName: String?
    var address: String?
    var occupiedSpots: Int?
    var emptySpots: Int?
    var maxBikes: Int?
    var lastSyncDate: String?
    var idStatus: Int?
    var status: String?
    var statusType: String?
    var coordinate: CLLocationCoordinate2D?
    var isValid: Bool?
    var customIsValid: Bool?
    var notifies: [Any]?
    var identifier: Int?
    
    
    init(_ jsonDict: [String : Any]) {
        stationName = jsonDict["StationName"] as? String
        address = jsonDict["Address"] as? String
        occupiedSpots = jsonDict["OcuppiedSpots"] as? Int
        emptySpots = jsonDict["EmptySpots"] as? Int
        maxBikes = jsonDict["MaximumNumberOfBikes"] as? Int
        lastSyncDate = jsonDict["LastSyncDate"] as? String
        idStatus = jsonDict["IdStatus"] as? Int
        status = jsonDict["Status"] as? String
        statusType = jsonDict["StatusType"] as? String
        coordinate = CLLocationCoordinate2DMake(jsonDict["Latitude"] as! Double, jsonDict["Longitude"] as! Double)
        isValid = jsonDict["IsValid"] as? Bool
        customIsValid = jsonDict["CustomIsValid"] as? Bool
        notifies = jsonDict["Notifies"] as? [Any]
        identifier = jsonDict["Id"] as? Int
    }
}
