//
//  BusStop.swift
//  Transit
//
//  Created by Dan Hilton on 2/3/16.
//  Copyright © 2016 MissionData. All rights reserved.
//

import Foundation
import CoreLocation

open class BusStop {
    
    open var stopId: String?
    open var location: CLLocation?
    open var name: String?
    open var routes: [String]?
    
    public init(json: JSON) {
        stopId = json["StopID"].string
        location = CLLocation(latitude: json["Lat"].double!, longitude: json["Lon"].double!)
        name = json["Name"].string
        routes = [String]()
        for r in json["Routes"].array! {
            routes?.append(r.string!)
        }
    }
    
    public init(stopId:String?, latitude:Double?, longitude:Double?, name:String?) {
        self.stopId = stopId
        self.name = name
        if latitude != nil && longitude != nil {
            self.location = CLLocation(latitude: latitude!, longitude: longitude!)
        }
    }
}
