//
//  Transit.swift
//  transit
//
//  Created by Dan Hilton on 2/16/16.
//  Copyright © 2016 Dan Hilton. All rights reserved.
//

import Foundation

open class Transit {
    public typealias JSONSuccessHandler = (_ json: JSON, _ response: HTTPURLResponse) -> Void
    public typealias FailureHandler = (_ error: NSError) -> Void
    
    internal struct CallbackNotification {
        static let notificationName = "WmataCallbackNotificationName"
        static let optionsURLKey = "WmataCallbackNotificationOptionsURLKey"
    }
    
    internal struct WmataError {
        static let domain = "WmataErrorDomain"
        static let appOnlyAuthenticationErrorCode = 1
    }
    
    internal struct DataParameters {
        static let dataKey = "WmataDataParameterKey"
        static let fileNameKey = "WmataDataParameterFilename"
    }
    
    // MARK: - Properties
    
    internal(set) var apiURL: URL
    
    open var client: WmataClientProtocol
    
    // MARK: - Initializers
    
    public init(apiKey: String) {
        self.client = WmataAppOnlyClient(apiKey: apiKey)
        self.apiURL = URL(string: "https://api.wmata.com/")!
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - JSON Requests
    
    internal func jsonRequestWithPath(_ path: String, baseURL: URL, method: String, success: JSONSuccessHandler? = nil, failure: WmataHTTPRequest.FailureHandler? = nil) -> WmataHTTPRequest {
        
        let jsonSuccessHandler: WmataHTTPRequest.SuccessHandler = {
            data, response in
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.utility).async {
                do {
                    let jsonResult = try JSON.parse(jsonData: data)
                    DispatchQueue.main.async {
                        success?(jsonResult, response)
                    }
                } catch {
                    DispatchQueue.main.async {
                        failure?(NSError())
                    }
                }
            }
        }
        
        if method == "GET" {
            return self.client.get(path, baseURL: baseURL, success: jsonSuccessHandler, failure: failure)
        }
        else {
            return self.client.post(path, baseURL: baseURL, success: jsonSuccessHandler, failure: failure)
        }
    }
    
    internal func getJSONWithPath(_ path: String, baseURL: URL, success: JSONSuccessHandler?, failure: WmataHTTPRequest.FailureHandler?) -> WmataHTTPRequest {
        return self.jsonRequestWithPath(path, baseURL: baseURL, method: "GET", success: success, failure: failure)
    }
    
    internal func postJSONWithPath(_ path: String, baseURL: URL, success: JSONSuccessHandler?, failure: WmataHTTPRequest.FailureHandler?) -> WmataHTTPRequest {
        return self.jsonRequestWithPath(path, baseURL: baseURL, method: "POST", success: success, failure: failure)
    }
    
    
    
}
