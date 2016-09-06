//
//  BusRoute.swift
//  Transit
//
//  Created by Dan Hilton on 2/3/16.
//  Copyright © 2016 MissionData. All rights reserved.
//

import Foundation

open class BusRoute {
    
    open var routeId: String?
    open var name: String?
    open var description: String?
    
    public init(json: JSON) {
        routeId = json["RouteID"].string
        name = json["Name"].string
        description = json["LineDescription"].string
    }
}
