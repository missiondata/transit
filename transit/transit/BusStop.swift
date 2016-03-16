//
//  BusStop.swift
//  Transit
//
//  Created by Dan Hilton on 2/3/16.
//  Copyright © 2016 MissionData. All rights reserved.
//

import Foundation
import CoreLocation

public class BusStop {
    
    public var stopId: String?
    public var location: CLLocation?
    public var name: String?
    public var routes: [String]?
    
    public init(json: JSONValue) {
        stopId = json["StopID"].string
        location = CLLocation(latitude: json["Lat"].double!, longitude: json["Lon"].double!)
        name = json["Name"].string
        routes = [String]()
        for r in json["Routes"].array! {
            routes?.append(r.string!)
        }
    }
}