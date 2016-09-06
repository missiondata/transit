//
//  WmataClientProtocol.swift
//  transit
//
//  Created by Dan Hilton on 1/9/16.
//  Copyright © 2016 MissionData. All rights reserved.
//

import Foundation

public protocol WmataClientProtocol {
        
    func get(_ path: String, baseURL: URL, success: WmataHTTPRequest.SuccessHandler?, failure: WmataHTTPRequest.FailureHandler?) -> WmataHTTPRequest
    
    func post(_ path: String, baseURL: URL, success: WmataHTTPRequest.SuccessHandler?, failure: WmataHTTPRequest.FailureHandler?) -> WmataHTTPRequest
}
