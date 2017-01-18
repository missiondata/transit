//
//  Circulator.swift
//  transit
//
//  Created by Dan Hilton on 1/17/17.
//  Copyright © 2017 Dan Hilton. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash

public extension Transit {
    
    public func getCirculatorRoutes(success: @escaping([BusRoute]) -> (), failure: @escaping(Error) -> ()) {
        Alamofire.request("http://webservices.nextbus.com/service/publicXMLFeed?command=routeList&a=dc-circulator").response { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                var routes = [BusRoute]()
                let xml = SWXMLHash.parse(utf8Text)
                do {
                    for elem in xml["body"]["route"].all {
                        let tag = try elem.value(ofAttribute: "tag") as String
                        let title = try elem.value(ofAttribute: "title") as String
                        routes.append(BusRoute(routeId: tag, name: title))
                    
                    }
                    success(routes)
                }
                catch {
                    failure(error)
                }
            }
        }
    }
    
    public func getCirculatorStopsFor(route:String, success: @escaping([BusStop]) -> (), failure: @escaping (Error) -> ()) {
        Alamofire.request("http://webservices.nextbus.com/service/publicXMLFeed?command=routeConfig&a=dc-circulator&r=\(route)&terse").response { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                let xml = SWXMLHash.parse(utf8Text)
                do {
                    var stops = [BusStop]()
                    for elem in xml["body"]["route"]["stop"].all {
                        let stopId = try elem.value(ofAttribute: "stopId") as String
                        let name = try elem.value(ofAttribute: "title") as String
                        let lat = try elem.value(ofAttribute: "lat") as Double
                        let lon = try elem.value(ofAttribute: "lon") as Double
                        stops.append(BusStop(stopId: stopId, latitude: lat, longitude: lon, name: name))
                    }
                    success(stops)
                }
                catch {
                    failure(error)
                }
            }
        }
    }
    
    public func getCirculatorPredictionFor(stopdId:String, success: @escaping(BusPrediction) -> (), failure: @escaping(Error)->()) {
        Alamofire.request("http://webservices.nextbus.com/service/publicXMLFeed?command=predictions&a=dc-circulator&stopId=0001").response { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                var prediction: BusPrediction?
                let xml = SWXMLHash.parse(utf8Text)
                do {
                    let routeId = try xml["body"]["predictions"].value(ofAttribute: "routeTag") as String
                    let direction = try xml["body"]["predictions"]["direction"].value(ofAttribute: "title") as String
                    prediction = BusPrediction(directionText: direction, routeId: routeId)
                    for elem in xml["body"]["predictions"]["direction"]["prediction"].all {
                        let min = try elem.value(ofAttribute: "minutes") as Int
                        prediction!.addMinutes(min)
                    }
                    success(prediction!)
                }
                catch {
                    failure(error)
                }
                
            }
        }
    }
}
