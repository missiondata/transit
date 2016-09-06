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
        
    var dataEncoding: String.Encoding
    
    init(apiKey: String) {
        self.apiKey = apiKey
        self.dataEncoding = String.Encoding.utf8
    }
    
    func get(_ path: String, baseURL: URL, success: WmataHTTPRequest.SuccessHandler?, failure: WmataHTTPRequest.FailureHandler?) -> WmataHTTPRequest {
        let url = URL(string: path, relativeTo: baseURL)
        let method = "GET"
        
        let request = WmataHTTPRequest(URL: url!, method: method)
        request.successHandler = success
        request.failureHandler = failure
        request.dataEncoding = self.dataEncoding
        request.headers = ["api_key": self.apiKey]
        
        request.start()
        return request
    }
    
    func post(_ path: String, baseURL: URL, success: WmataHTTPRequest.SuccessHandler?, failure: WmataHTTPRequest.FailureHandler?) -> WmataHTTPRequest {
        let url = URL(string: path, relativeTo: baseURL)
        let method = "POST"
        
        let request = WmataHTTPRequest(URL: url!, method: method)
        request.successHandler = success
        request.failureHandler = failure
        request.dataEncoding = self.dataEncoding        
        request.headers = ["api_key": self.apiKey]

        request.start()
        return request
    }
    
    class func base64EncodedCredentialsWithKey(_ key: String, secret: String) -> String {
        let encodedKey = key.urlEncodedString()
        let encodedSecret = secret.urlEncodedString()
        let bearerTokenCredentials = "\(encodedKey):\(encodedSecret)"
        if let data = bearerTokenCredentials.data(using: String.Encoding.utf8) {
            return data.base64EncodedString(options: [])
        }
        return String()
    }

}
