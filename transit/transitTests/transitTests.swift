//
//  transitTests.swift
//  transitTests
//
//  Created by Dan Hilton on 2/16/16.
//  Copyright © 2016 Dan Hilton. All rights reserved.
//

import XCTest
import Alamofire
import SWXMLHash
import Transit
@testable import Transit

class transitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let e = expectation(description: "blah")
        
        Alamofire.request("http://webservices.nextbus.com/service/publicXMLFeed?command=routeList&a=dc-circulator").response { response in
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                var routes = [BusRoute]()
                let xml = SWXMLHash.parse(utf8Text)
                for elem in xml["body"]["route"].all {
                    do {
                        let tag = try elem.value(ofAttribute: "tag") as String
                        let title = try elem.value(ofAttribute: "title") as String
                        routes.append(BusRoute(routeId: tag, name: title))
                    }
                    catch {
                        debugPrint(error)
                    }
                }
                e.fulfill()
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testCirculatorPrediction() {
        let e = expectation(description: "blah")
        
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
                    e.fulfill()
                }
                catch {
                    debugPrint(error)
                }

            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
