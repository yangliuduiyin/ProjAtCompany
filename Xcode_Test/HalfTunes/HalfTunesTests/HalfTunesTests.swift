//
//  HalfTunesTests.swift
//  HalfTunesTests
//
//  Created by admin-3k on 2018/12/21.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

/**
 First Things FIRST: Best Practices for Testing
 The acronym FIRST describes a concise set of criteria for effective unit tests. Those criteria are:
 
  ** Fast: Tests should run quickly, so people won’t mind running them.
  ** Independent/Isolated: Tests should not do setup or teardown for one another.
  ** Repeatable: You should obtain the same results every time you run a test. External data providers and concurrency issues could cause intermittent failures.
  ** Self-validating: Tests should be fully automated; the output should be either “pass” or “fail”, rather than a programmer’s interpretation of a log file.
  ** Timely: Ideally, tests should be written just before you write the production code they test.
 */
import XCTest
@testable import HalfTunes


var sessionUnderTest: URLSession!

class HalfTunesTests: XCTestCase {

    override func setUp() {
        super.setUp()
        sessionUnderTest = URLSession(configuration: .default)
        
    }

    override func tearDown() {
        sessionUnderTest = nil
        super.tearDown()
    }

    func testValidCallToiTunesGetsHTTPStatusCode200() {
        // given
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
        // 1.
        let promise = expectation(description: "Status code: 200")
        
        // when
        let dataTask = sessionUnderTest.dataTask(with: url!) { (data, response, error) in
            // then
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            }else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    // 2.
                    promise.fulfill()
                }else {
                    XCTFail("Status Code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        // 3.
        waitForExpectations(timeout: 5) { (error) in
            
        }
    }
    
    // Asynchronous test: faster fail
    func testCallToiTunesCompletes() {
        // given
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
        // 1
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            // 2
            promise.fulfill()
        }
        dataTask.resume()
        // 3
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
