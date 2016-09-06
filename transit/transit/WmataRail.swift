//
//  WmataRail.swift
//  transit
//
//  Created by Dan Hilton on 1/14/16.
//  Copyright © 2016 MissionData. All rights reserved.
//

import Foundation

public extension Transit {
    
    public func getRailLines(_ success: JSONSuccessHandler? = nil, failure: FailureHandler? = nil) {
        let path = "Rail.svc/json/jLines"
        self.getJSONWithPath(path, baseURL: self.apiURL, success: success, failure: failure)
    }
    
    public func getParkingInformation(_ stationCode: String?, success: JSONSuccessHandler? = nil, failure: FailureHandler? = nil) {
        let path = "Rail.svc/json/jStationParking?StationCode=\(stationCode != nil ? stationCode! : "")"
        self.getJSONWithPath(path, baseURL: self.apiURL, success: success, failure: failure)
    }
    
    public func getPathBetweenStations(_ fromStationCode: String, toStationCode: String, success: JSONSuccessHandler? = nil, failure: FailureHandler? = nil) {
        let path = "Rail.svc/json/jPath?FromStationCode=\(fromStationCode)&ToStationCode=\(toStationCode)"
        self.getJSONWithPath(path, baseURL: self.apiURL, success: success, failure: failure)
    }
    
    public func getStationEntrances(_ lat: Float?, long: Float?, radius: Float?, success: JSONSuccessHandler? = nil, failure: FailureHandler? = nil) {
        let path = "Rail.svc/json/jStationEntrances?Lat=\(lat != nil ?  "\(lat!)" : "")&Lon=\(long != nil ? "\(long!)" : "")&Radius=\(radius != nil ? "\(radius!)" : "")"
        self.getJSONWithPath(path, baseURL: self.apiURL, success: success, failure: failure)
    }
    
    public func getStationInformation(_ stationCode: String, success: JSONSuccessHandler? = nil, failure: FailureHandler? = nil) {
        let path = "Rail.svc/json/jStationInfo?StationCode=\(stationCode)"
        self.getJSONWithPath(path, baseURL: self.apiURL, success: success, failure: failure)
    }
    
    public func getStationList(_ lineCode: String?, success: JSONSuccessHandler? = nil, failure: FailureHandler? = nil) {
        let path = "Rail.svc/json/jStations?LineCode=\(lineCode != nil ? lineCode! : "")"
        self.getJSONWithPath(path, baseURL: self.apiURL, success: success, failure: failure)
    }
    
    public func getStationTimes(_ stationCode: String?, success: JSONSuccessHandler? = nil, failure: FailureHandler? = nil) {
        let path = "Rail.svc/json/jStationTimes?StationCode=\(stationCode != nil ? stationCode! : "")"
        self.getJSONWithPath(path, baseURL: self.apiURL, success: success, failure: failure)
    }
    
    public func getStationToStationInformation(_ fromStationCode: String?, toStationCode: String?, success: JSONSuccessHandler? = nil, failure: FailureHandler? = nil) {
        let path = "Rail.svc/json/jSrcStationToDstStationInfo?FromStationCode=\(fromStationCode != nil ? fromStationCode! : "")&ToStationCode=\(toStationCode != nil ? toStationCode! : "")"
        self.getJSONWithPath(path, baseURL: self.apiURL, success: success, failure: failure)
    }
    
    public func getNextTrainAtStation(_ stationCodes: String, success: JSONSuccessHandler? = nil, failure: FailureHandler? = nil) {
        let path = "StationPrediction.svc/json/GetPrediction/\(stationCodes)"
        self.getJSONWithPath(path, baseURL: self.apiURL, success: success, failure: failure)
    }

    
}
