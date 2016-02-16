//
//  BusRoute.swift
//  Transit
//
//  Created by Dan Hilton on 2/3/16.
//  Copyright © 2016 MissionData. All rights reserved.
//

import Foundation

public class BusRoute {
    
    var routeId: String?
    var name: String?
    var description: String?
    
    init(json: JSONValue) {
        routeId = json["RouteID"].string
        name = json["Name"].string
        description = json["LineDescription"].string
    }
}