//
//  WmataHTTPRequest.swift
//  transit
//
//  Created by Dan Hilton on 1/9/16.
//  Copyright © 2016 MissionData. All rights reserved.
//

import Foundation
#if os(iOS)
    import UIKit
#else
    import AppKit
#endif

open class WmataHTTPRequest: NSObject, NSURLConnectionDataDelegate {
    
    public typealias SuccessHandler = (_ data: Data, _ response: HTTPURLResponse) -> Void
    public typealias FailureHandler = (_ error: NSError) -> Void
    
    let URL: Foundation.URL
    let HTTPMethod: String
    
    var request: NSMutableURLRequest?
    var connection: NSURLConnection!
    
    var headers: Dictionary<String, String>
    var encodeParameters: Bool
    
    var dataEncoding: String.Encoding
    
    var timeoutInterval: TimeInterval
    
    var HTTPShouldHandleCookies: Bool
    
    var response: HTTPURLResponse!
    var responseData: NSMutableData
    
    var successHandler: SuccessHandler?
    var failureHandler: FailureHandler?
    
    public convenience init(URL: Foundation.URL) {
        self.init(URL: URL, method: "GET")
    }
    
    public init(URL: Foundation.URL, method: String) {
        self.URL = URL
        self.HTTPMethod = method
        self.headers = [:]
        self.encodeParameters = false
        self.dataEncoding = String.Encoding.utf8
        self.timeoutInterval = 60
        self.HTTPShouldHandleCookies = false
        self.responseData = NSMutableData()
    }
    
    public init(request: URLRequest) {
        self.request = request as? NSMutableURLRequest
        self.URL = request.url!
        self.HTTPMethod = request.httpMethod!
        self.headers = [:]
        self.encodeParameters = true
        self.dataEncoding = String.Encoding.utf8
        self.timeoutInterval = 60
        self.HTTPShouldHandleCookies = false
        self.responseData = NSMutableData()
    }
    
    open func start() {
        if request == nil {
            self.request = NSMutableURLRequest(url: self.URL)
            self.request!.httpMethod = self.HTTPMethod
            self.request!.timeoutInterval = self.timeoutInterval
            self.request!.httpShouldHandleCookies = self.HTTPShouldHandleCookies
            
            for (key, value) in headers {
                self.request!.setValue(value, forHTTPHeaderField: key)
            }
            
        }
        
        DispatchQueue.main.async {
            self.connection = NSURLConnection(request: self.request! as URLRequest, delegate: self)
            self.connection.start()
            
            #if os(iOS)
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            #endif
        }
    }
    
    open func stop() {
        self.connection.cancel()
    }
    
    open func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        self.response = response as? HTTPURLResponse
        
        self.responseData.length = 0
    }
    
    open func connection(_ connection: NSURLConnection, didReceive data: Data) {
        self.responseData.append(data)
    }
    
    open func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        #if os(iOS)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        #endif
        
        self.failureHandler?(error as NSError)
    }
    
    open func connectionDidFinishLoading(_ connection: NSURLConnection) {
        #if os(iOS)
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        #endif
        
        if self.response.statusCode >= 400 {
            let responseString = NSString(data: self.responseData as Data, encoding: self.dataEncoding.rawValue)
            let responseErrorCode = WmataHTTPRequest.responseErrorCode(self.responseData as Data) ?? 0
            let localizedDescription = WmataHTTPRequest.descriptionForHTTPStatus(self.response.statusCode, responseString: responseString! as String)
            let userInfo = [
                NSLocalizedDescriptionKey: localizedDescription,
                "Response-Headers": self.response.allHeaderFields,
                "Response-ErrorCode": responseErrorCode] as [String : Any]
            let error = NSError(domain: NSURLErrorDomain, code: self.response.statusCode, userInfo: userInfo as [NSObject : AnyObject])
            self.failureHandler?(error)
            return
        }
        
        self.successHandler?(self.responseData as Data, self.response)
    }

    class func responseErrorCode(_ data: Data) -> Int? {
        guard let code = JSON(data)["errors"].array?.first?["code"].integer else {
            return nil
        }
        return code
    }
    
    class func descriptionForHTTPStatus(_ status: Int, responseString: String) -> String {
        var s = "HTTP Status \(status)"
        
        var description: String?
        // http://www.iana.org/assignments/http-status-codes/http-status-codes.xhtml
        if status == 400 { description = "Bad Request" }
        if status == 401 { description = "Unauthorized" }
        if status == 402 { description = "Payment Required" }
        if status == 403 { description = "Forbidden" }
        if status == 404 { description = "Not Found" }
        if status == 405 { description = "Method Not Allowed" }
        if status == 406 { description = "Not Acceptable" }
        if status == 407 { description = "Proxy Authentication Required" }
        if status == 408 { description = "Request Timeout" }
        if status == 409 { description = "Conflict" }
        if status == 410 { description = "Gone" }
        if status == 411 { description = "Length Required" }
        if status == 412 { description = "Precondition Failed" }
        if status == 413 { description = "Payload Too Large" }
        if status == 414 { description = "URI Too Long" }
        if status == 415 { description = "Unsupported Media Type" }
        if status == 416 { description = "Requested Range Not Satisfiable" }
        if status == 417 { description = "Expectation Failed" }
        if status == 422 { description = "Unprocessable Entity" }
        if status == 423 { description = "Locked" }
        if status == 424 { description = "Failed Dependency" }
        if status == 425 { description = "Unassigned" }
        if status == 426 { description = "Upgrade Required" }
        if status == 427 { description = "Unassigned" }
        if status == 428 { description = "Precondition Required" }
        if status == 429 { description = "Too Many Requests" }
        if status == 430 { description = "Unassigned" }
        if status == 431 { description = "Request Header Fields Too Large" }
        if status == 432 { description = "Unassigned" }
        if status == 500 { description = "Internal Server Error" }
        if status == 501 { description = "Not Implemented" }
        if status == 502 { description = "Bad Gateway" }
        if status == 503 { description = "Service Unavailable" }
        if status == 504 { description = "Gateway Timeout" }
        if status == 505 { description = "HTTP Version Not Supported" }
        if status == 506 { description = "Variant Also Negotiates" }
        if status == 507 { description = "Insufficient Storage" }
        if status == 508 { description = "Loop Detected" }
        if status == 509 { description = "Unassigned" }
        if status == 510 { description = "Not Extended" }
        if status == 511 { description = "Network Authentication Required" }
        
        if description != nil {
            s = s + ": " + description! + ", Response: " + responseString
        }
        
        return s
    }
    
}
