//
//  HalfTunesFakeTests.swift
//  HalfTunesFakeTests
//
//  Created by admin-3k on 2018/12/21.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import XCTest
@testable import HalfTunes

var controllerUnderTest: SearchViewController!

class HalfTunesFakeTests: XCTestCase {

    override func setUp() {
       super.setUp()
        controllerUnderTest = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! SearchViewController!
        
        // 1.
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "abbaData", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
        let urlResponse = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let sessionMock = URLSessionMock(data: data, response: urlResponse, error: nil)

        // 2.
        controllerUnderTest.defaultSession = sessionMock
        
        
    }

    override func tearDown() {
        controllerUnderTest = nil
        super.tearDown()
    }

    func test_UpdateSearchResults_ParsesData() {
        // given
        let promise = expectation(description: "Status Code: 200")
        
        // when
        XCTAssertEqual(controllerUnderTest.searchResults.count, 0, "earchResults should be empty before the data task runs")
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
        let dataTask = controllerUnderTest.defaultSession.dataTask(with: url!) { (data, response, error) in
             // if HTTP request is successful, call updateSearchResults(_:) which parses the response data into Tracks
            if let error = error {
                print(error.localizedDescription)
            }else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    promise.fulfill()
                    controllerUnderTest.updateSearchResults(data)
                }
            }
        }
        dataTask.resume()
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssertEqual(controllerUnderTest.searchResults.count, 3,  "Didn't parse 3 items from fake response")
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
