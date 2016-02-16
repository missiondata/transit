//
//  Transit.swift
//  transit
//
//  Created by Dan Hilton on 2/16/16.
//  Copyright © 2016 Dan Hilton. All rights reserved.
//

import Foundation

public class Transit {
    public typealias JSONSuccessHandler = (json: JSON, response: NSHTTPURLResponse) -> Void
    public typealias FailureHandler = (error: NSError) -> Void
    
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
    
    internal(set) var apiURL: NSURL
    
    public var client: WmataClientProtocol
    
    // MARK: - Initializers
    
    public init(apiKey: String) {
        self.client = WmataAppOnlyClient(apiKey: apiKey)
        self.apiURL = NSURL(string: "https://api.wmata.com/")!
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - JSON Requests
    
    internal func jsonRequestWithPath(path: String, baseURL: NSURL, method: String, success: JSONSuccessHandler? = nil, failure: WmataHTTPRequest.FailureHandler? = nil) -> WmataHTTPRequest {
        
        let jsonSuccessHandler: WmataHTTPRequest.SuccessHandler = {
            data, response in
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) {
                var error: NSError?
                do {
                    let jsonResult = try JSON.parseJSONData(data)
                    dispatch_async(dispatch_get_main_queue()) {
                        if let success = success {
                            success(json: jsonResult, response: response)
                        }
                    }
                } catch let error1 as NSError {
                    error = error1
                    dispatch_async(dispatch_get_main_queue()) {
                        if let failure = failure {
                            failure(error: error!)
                        }
                    }
                } catch {
                    fatalError()
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
    
    internal func getJSONWithPath(path: String, baseURL: NSURL, success: JSONSuccessHandler?, failure: WmataHTTPRequest.FailureHandler?) -> WmataHTTPRequest {
        return self.jsonRequestWithPath(path, baseURL: baseURL, method: "GET", success: success, failure: failure)
    }
    
    internal func postJSONWithPath(path: String, baseURL: NSURL, success: JSONSuccessHandler?, failure: WmataHTTPRequest.FailureHandler?) -> WmataHTTPRequest {
        return self.jsonRequestWithPath(path, baseURL: baseURL, method: "POST", success: success, failure: failure)
    }
    
    
    
}