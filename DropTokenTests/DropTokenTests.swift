//
//  DropTokenTests.swift
//  DropTokenTests
//
//  Created by Amar Makana on 5/19/21.
//

import XCTest
@testable import DropToken

class DropTokenTests: XCTestCase {

    var viewController: ViewController!
    
    override func setUpWithError() throws {
        viewController = ViewController()
        viewController.resetVisits()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewController = nil
    }

    func testWinner1(){
        let turns = [3, 0, 3, 2, 3, 2, 3, 0]

        viewController.simulatePlays(for: turns)
        XCTAssertTrue(viewController.validateBoardForTests())
    }
    
    func testWinner2() {
        let turns = [0, 1, 3, 1, 2, 1, 0, 1, 3]

        viewController.simulatePlays(for: turns)
        XCTAssertTrue(viewController.validateBoardForTests())
    }
    
    func testWinner3() {
        let turns = [1, 1, 1, 1, 2, 2, 0, 0, 3, 0, 0, 3]

        viewController.simulatePlays(for: turns)
        XCTAssertTrue(viewController.validateBoardForTests())
    }
    
    func testWinner4() {
        let turns = [3, 0, 0, 2, 2, 3, 1, 1, 1, 0, 0, 2]  // Diagonal 1
        
        viewController.simulatePlays(for: turns)
        XCTAssertTrue(viewController.validateBoardForTests())
    }
    
    func testWinner5() {
        let turns = [0, 1, 1, 3, 2, 2, 2, 1, 3, 3, 3]  // Diagonal 2

        viewController.simulatePlays(for: turns)
        XCTAssertTrue(viewController.validateBoardForTests())
    }
    
    func testNoWinner1() {
        let turns = [3, 0, 3, 2, 3, 2, 1, 1]

        viewController.simulatePlays(for: turns)
        XCTAssertFalse(viewController.validateBoardForTests())
    }
    
    func testNoWinner2() {
        let turns = [1, 1, 1, 1, 2, 2, 0, 0]

        viewController.simulatePlays(for: turns)
        XCTAssertFalse(viewController.validateBoardForTests())
    }
}
