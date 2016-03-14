//
//  BusPrediction.swift
//  Transit
//
//  Created by Dan Hilton on 2/3/16.
//  Copyright © 2016 MissionData. All rights reserved.
//

import Foundation

public class BusPrediction {

    var directionNum: Int?
    var directionText: String?
    var minutes: [Int]?
    var routeId: String?
    var tripId: String?
    var vehicleId: String?
    
    init(json: JSONValue) {
        self.directionNum = Int(json["DirectionNum"].string!)
        self.directionText = json["DirectionText"].string
        self.addMinutes(json["Minutes"].integer!)
        self.routeId = json["RouteID"].string
        self.tripId = json["TripID"].string
        self.vehicleId = json["VehicleID"].string
    }
    
    public func addMinutes(min: Int) {
        if self.minutes == nil {
            self.minutes = [Int]()
        }
        self.minutes!.append(min)
    }
    
    public func minutesToString() -> String {
        return minutes != nil ? minutes!.map { String($0) + "m" }.joinWithSeparator(", ") : ""
    }

}
