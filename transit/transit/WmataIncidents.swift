//
//  WmataIncidents.swift
//  transit
//
//  Created by Dan Hilton on 1/14/16.
//  Copyright © 2016 MissionData. All rights reserved.
//

import Foundation

public extension Transit {
    
    public func getBusIncidents(routeId: String?, success: JSONSuccessHandler? = nil, failure: FailureHandler? = nil) {
        let path = "Incidents.svc/json/BusIncidents?Route=\(routeId != nil ?  routeId! : "")"
        self.getJSONWithPath(path, baseURL: self.apiURL, success: success, failure: failure)
    }
    
    public func getElevatorAndEscalatorOutages(stationCode: String?, success: JSONSuccessHandler? = nil, failure: FailureHandler? = nil) {
        let path = "Incidents.svc/json/ElevatorIncidents?StationCode=\(stationCode != nil ? stationCode! : "")"
        self.getJSONWithPath(path, baseURL: self.apiURL, success: success, failure: failure)
    }
    
    public func getRailIncidents(success: JSONSuccessHandler? = nil, failure: FailureHandler? = nil) {
        let path = "Incidents.svc/json/Incidents"
        self.getJSONWithPath(path, baseURL: self.apiURL, success: success, failure: failure)
    }
    
}