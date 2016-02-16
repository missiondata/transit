//
//  WmataBus.swift
//  transit
//
//  Created by Dan Hilton on 1/9/16.
//  Copyright © 2016 MissionData. All rights reserved.
//

import Foundation
import CoreLocation

public extension Transit {
    
    public func getBusPosition(routeId: String?, lat: Float?, long: Float?, radius: Float?, success: JSONSuccessHandler? = nil, failure: FailureHandler? = nil) {
        let path = "Bus.svc/json/jBusPositions?RouteId=\(routeId != nil ? routeId! : "")&Lat=\(lat != nil ? "\(lat!)" : "")&Lon=\(long != nil ? "\(long!)" : "")&Radius=\(radius != nil ? "\(radius!)" : "")"
        self.getJSONWithPath(path, baseURL: self.apiURL, success: success, failure: failure)
    }
    
    public func getBusPathDetails(routeId: String, date: String?, success: JSONSuccessHandler? = nil, failure: FailureHandler? = nil) {
        let path = "Bus.svc/json/jRouteDetails?RouteId=\(routeId)&Date=\(date != nil ? date! : "")"
        self.getJSONWithPath(path, baseURL: self.apiURL, success: success, failure: failure)
    }
    
    public func getBusRoutes(success: JSONSuccessHandler? = nil, failure: FailureHandler? = nil) {
        let path = "Bus.svc/json/jRoutes"
        self.getJSONWithPath(path, baseURL: self.apiURL, success: success, failure: failure)
    }
    
    public func getBusRoutes(success: ([BusRoute]->Void), failure: FailureHandler? = nil) {
        let path = "Bus.svc/json/jRoutes"
        self.getJSONWithPath(path, baseURL: self.apiURL,
            success: { (json, response) -> Void in
                if let arr = json["Routes"].array {
                    var routes = [BusRoute]()
                    for a in arr {
                        routes.append(BusRoute(json: a))
                    }
                    success(routes)
                }
            }, failure: failure)
    }
    
    public func getBusSchedule(routeId: String, date: String?, includingVariations: Bool?, success: JSONSuccessHandler? = nil, failure: FailureHandler? = nil) {
        let path = "Bus.svc/json/jRouteSchedule?RouteId=\(routeId)&Date=\(date != nil ? date! : "")&includingVariations=\(includingVariations == true ? "true" : "false")"
        self.getJSONWithPath(path, baseURL: self.apiURL, success: success, failure: failure)
    }
    
    public func getBusScheduleAtStop(stopId: String, date: String?, success: JSONSuccessHandler? = nil, failure: FailureHandler? = nil) {
        let path = "Bus.svc/json/jStopSchedule?StopID=\(stopId)&Date=\(date != nil ? date! : "")"
        self.getJSONWithPath(path, baseURL: self.apiURL, success: success, failure: failure)
    }
    
    public func getBusStops(location: CLLocation?, radius: Double, success: ([BusStop]-> Void), failure: FailureHandler? = nil) {
        let path: String?
        if location != nil {
            path = "Bus.svc/json/jStops?&Lat=\(location!.coordinate.latitude)&Lon=\(location!.coordinate.longitude)&Radius=\(radius)"
        }
        else {
            path = "Bus.svc/json/jStops?Radius=\(radius)"
        }
        self.getJSONWithPath(path!, baseURL: self.apiURL,
            success: { (json, response) -> Void in
                if let arr = json["Stops"].array {
                    var stops = [BusStop]()
                    for a in arr {
                        stops.append(BusStop(json: a))
                    }
                    success(stops)
                }
            }, failure: failure)
    }
    
    public func getNextBusAtStop(stopId: String, success: JSONSuccessHandler? = nil, failure: FailureHandler? = nil) {
        let path = "NextBusService.svc/json/jPredictions?StopID=\(stopId)"
        self.getJSONWithPath(path, baseURL: self.apiURL, success: success, failure: failure)
    }
    
    public func getBusPredictions(stopId: String, success: ([BusPrediction])->Void, failure: FailureHandler? = nil) {
        let path = "NextBusService.svc/json/jPredictions?StopID=\(stopId)"
        self.getJSONWithPath(path, baseURL: self.apiURL,
            success: { (json, response) -> Void in
                if let arr = json["Predictions"].array {
                    var predictions = [BusPrediction]()
                    for a in arr {
                        let found = predictions.indexOf({ (bp: BusPrediction) -> Bool in
                            return (bp.routeId == a["RouteID"].string && bp.directionNum == Int(a["DirectionNum"].string!))
                        })
                        if found == nil {
                            predictions.append(BusPrediction(json: a))
                        }
                        else {
                            predictions[found!].addMinutes(a["Minutes"].integer!)
                        }
                    }
                    success(predictions)
                }
            }, failure: failure)
    }
}