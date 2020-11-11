//
//  BakuSnakeTests.swift
//  BakuSnakeTests
//
//  Created by 陳昱宏 on 2020/10/31.
//

import XCTest
@testable import BakuSnake

class BakuSnakeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testChangeDirection(){
        let testSnake = Snake(maxX: 100, maxY: 100)
        testSnake.changeDirection(to: .SnakeFacingDown)
        XCTAssertEqual(testSnake.getDirection(), .SnakeFacingDown, "Must be facing down.")
        
        testSnake.changeDirection(to: .SnakeFacingLeft)
        XCTAssertEqual(testSnake.getDirection(), .SnakeFacingLeft, "Must be facing left.")
        
        testSnake.changeDirection(to: .SnakeFacingRight)
        XCTAssertEqual(testSnake.getDirection(), .SnakeFacingLeft, "Must be facing left.")
        
    }
    
    func testIncreaseLength(){
        let testSnake = Snake(maxX: 100, maxY: 100)
        testSnake.increaseLength()
        XCTAssertEqual(testSnake.getLength(), 3, "Must be 3.")
        testSnake.move()
        let movedSnake = testSnake.getBody()
        XCTAssertEqual(movedSnake.first!.0, 49, "Must be 49 of (49,50).")
        XCTAssertEqual(movedSnake.first!.1, 50, "Must be 50 of (49,50).")
        XCTAssertEqual(movedSnake.last!.0, 51, "Must be 51 of (51,50).")
        XCTAssertEqual(movedSnake.last!.1, 50, "Must be 50 of (51,50).")
    }
    
    func testMove(){
        let testSnake = Snake(maxX: 100, maxY: 100)
        testSnake.increaseLength()
        testSnake.move()
        var movedSnake = testSnake.getBody()
        XCTAssertEqual(movedSnake.first!.0, 49, "Must be 49 of (49,50).")
        XCTAssertEqual(movedSnake.first!.1, 50, "Must be 50 of (49,50).")
        XCTAssertEqual(movedSnake.last!.0, 51, "Must be 51 of (51,50).")
        XCTAssertEqual(movedSnake.last!.1, 50, "Must be 50 of (51,50).")
        testSnake.move()
        movedSnake = testSnake.getBody()
        XCTAssertEqual(movedSnake.first!.0, 50, "Must be 50 of (50,50).")
        XCTAssertEqual(movedSnake.first!.1, 50, "Must be 50 of (50,50).")
        XCTAssertEqual(movedSnake.last!.0, 52, "Must be 52 of (52,50).")
        XCTAssertEqual(movedSnake.last!.1, 50, "Must be 50 of (52,50).")
        testSnake.changeDirection(to: .SnakeFacingDown)
        testSnake.move()
        movedSnake = testSnake.getBody()
        XCTAssertEqual(movedSnake.first!.0, 51, "Must be 51 of (51,50).")
        XCTAssertEqual(movedSnake.first!.1, 50, "Must be 50 of (51,50).")
        XCTAssertEqual(movedSnake.last!.0, 52, "Must be 52 of (52,51).")
        XCTAssertEqual(movedSnake.last!.1, 51, "Must be 51 of (52,51).")
    }
    
    func testIsHitBody(){
        let testSnake = Snake(maxX: 100, maxY: 100, diretion: .SnakeFacingRight, bodyLength: 6)
        testSnake.changeDirection(to: .SnakeFacingUp)
        testSnake.move()
        testSnake.changeDirection(to: .SnakeFacingLeft)
        testSnake.move()
        testSnake.changeDirection(to: .SnakeFacingDown)
        testSnake.move()
        XCTAssertEqual(testSnake.isHitBody(), true, "Must be true means hit the body.")
    }
    
    func testIsHitPoint(){
        let testSnake = Snake(maxX: 100, maxY: 100)
        testSnake.move()
        testSnake.move()
        XCTAssertEqual(testSnake.isHitPoint(x: 52, y: 52), false, "Must be true means got the point.")
        testSnake.changeDirection(to: .SnakeFacingDown)
        testSnake.move()
        testSnake.move()
        XCTAssertEqual(testSnake.isHitPoint(x: 52, y: 52), true, "Must be true means got the point.")
        
    }

}
