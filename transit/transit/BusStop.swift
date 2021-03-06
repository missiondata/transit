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
    open var circulator: Bool?
    
    public init(json: JSON) {
        stopId = json["StopID"].string
        location = CLLocation(latitude: json["Lat"].double!, longitude: json["Lon"].double!)
        name = json["Name"].string
        routes = [String]()
        if let arr = json["Routes"].array {
            for r in arr {
                routes?.append(r.string!)
            }
        }
        circulator = json["Circulator"].bool ?? false
    }
    
    public init(stopId:String?, latitude:Double?, longitude:Double?, name:String?, circulator:Bool?, route:String?) {
        self.stopId = stopId
        self.name = name
        if latitude != nil && longitude != nil {
            self.location = CLLocation(latitude: latitude!, longitude: longitude!)
        }
        if route != nil {
            self.routes = [String]()
            self.routes!.append(route!)
        }
        
        self.circulator = circulator
    }
}
