//
//  WmataAppOnlyClient.swift
//  transit
//
//  Created by Dan Hilton on 1/9/16.
//  Copyright © 2016 MissionData. All rights reserved.
//

import Foundation

internal class WmataAppOnlyClient: WmataClientProtocol {
    var apiKey: String
        
    var dataEncoding: NSStringEncoding
    
    init(apiKey: String) {
        self.apiKey = apiKey
        self.dataEncoding = NSUTF8StringEncoding
    }
    
    func get(path: String, baseURL: NSURL, success: WmataHTTPRequest.SuccessHandler?, failure: WmataHTTPRequest.FailureHandler?) -> WmataHTTPRequest {
        let url = NSURL(string: path, relativeToURL: baseURL)
        let method = "GET"
        
        let request = WmataHTTPRequest(URL: url!, method: method)
        request.successHandler = success
        request.failureHandler = failure
        request.dataEncoding = self.dataEncoding
        request.headers = ["api_key": self.apiKey]
        
        request.start()
        return request
    }
    
    func post(path: String, baseURL: NSURL, success: WmataHTTPRequest.SuccessHandler?, failure: WmataHTTPRequest.FailureHandler?) -> WmataHTTPRequest {
        let url = NSURL(string: path, relativeToURL: baseURL)
        let method = "POST"
        
        let request = WmataHTTPRequest(URL: url!, method: method)
        request.successHandler = success
        request.failureHandler = failure
        request.dataEncoding = self.dataEncoding        
        request.headers = ["api_key": self.apiKey]

        request.start()
        return request
    }
    
    class func base64EncodedCredentialsWithKey(key: String, secret: String) -> String {
        let encodedKey = key.urlEncodedStringWithEncoding(NSUTF8StringEncoding)
        let encodedSecret = secret.urlEncodedStringWithEncoding(NSUTF8StringEncoding)
        let bearerTokenCredentials = "\(encodedKey):\(encodedSecret)"
        if let data = bearerTokenCredentials.dataUsingEncoding(NSUTF8StringEncoding) {
            return data.base64EncodedStringWithOptions([])
        }
        return String()
    }

}