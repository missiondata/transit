//
//  BusPrediction.swift
//  Transit
//
//  Created by Dan Hilton on 2/3/16.
//  Copyright © 2016 MissionData. All rights reserved.
//

import Foundation

open class BusPrediction {

    open var directionNum: Int?
    open var directionText: String?
    open var minutes: [Int]?
    open var routeId: String?
    open var tripId: String?
    open var vehicleId: String?
    
    init(json: JSON) {
        self.directionNum = Int(json["DirectionNum"].string!)
        self.directionText = json["DirectionText"].string
        self.addMinutes(json["Minutes"].integer!)
        self.routeId = json["RouteID"].string
        self.tripId = json["TripID"].string
        self.vehicleId = json["VehicleID"].string
    }
    
    init(directionText:String?, routeId:String?) {
        self.directionText = directionText
        self.routeId = routeId
    }
    
    open func addMinutes(_ min: Int) {
        if self.minutes == nil {
            self.minutes = [Int]()
        }
        self.minutes!.append(min)
    }
    
    open func minutesToString() -> String {
        return minutes != nil ? minutes!.map { String($0) + "m" }.joined(separator: ", ") : ""
    }

}
