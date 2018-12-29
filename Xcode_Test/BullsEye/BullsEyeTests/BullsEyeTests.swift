//
//  BullsEyeTests.swift
//  BullsEyeTests
//
//  Created by admin-3k on 2018/12/21.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import XCTest
@testable import BullsEye
var gameUnderTest: BullsEyeGame!

class BullsEyeTests: XCTestCase {

    override func setUp() {
        super.setUp()
        gameUnderTest = BullsEyeGame()
        gameUnderTest.startNewGame()
    }

    override func tearDown() {
        gameUnderTest = nil
        super.tearDown()
    }
    
    /**
     A test method’s name always begins with test, followed by a description of what it tests.
     
     It’s good practice to format the test into given, when and then sections:
         * given
         * when
         * then
     */
    
    func testScoreIsComputed() {
        // 1.given
        let guess = gameUnderTest.targetValue + 5
        // 2. when
        _ = gameUnderTest.check(guess: guess)
        
        // 3. then
        XCTAssertEqual(gameUnderTest.scoreRound, 95, "Score computed from guess is wrong")
    }

    func testExample() {
       
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
