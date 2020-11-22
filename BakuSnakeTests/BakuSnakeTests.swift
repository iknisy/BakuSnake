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
        let testSnake = Snake(maxX: 100, maxY: 100, diretion: .SnakeFacingRight, bodyLength: 2)
        testSnake.changeDirection(to: .SnakeFacingDown)
        XCTAssertEqual(testSnake.facing, .SnakeFacingDown, "Must be facing down.")
        
        testSnake.changeDirection(to: .SnakeFacingLeft)
        XCTAssertEqual(testSnake.facing, .SnakeFacingLeft, "Must be facing left.")
        
        testSnake.changeDirection(to: .SnakeFacingRight)
        XCTAssertEqual(testSnake.facing, .SnakeFacingLeft, "Must be facing left.")
        
    }
    
    func testIncreaseLength(){
        let testSnake = Snake(maxX: 100, maxY: 100, diretion: .SnakeFacingRight, bodyLength: 2)
        testSnake.increaseLength()
        XCTAssertEqual(testSnake.length, 3, "Must be 3.")
        testSnake.move()
        let movedSnake = testSnake.body
        XCTAssertEqual(movedSnake.first!.0, 49, "Must be 49 of (49,50).")
        XCTAssertEqual(movedSnake.first!.1, 50, "Must be 50 of (49,50).")
        XCTAssertEqual(movedSnake.last!.0, 51, "Must be 51 of (51,50).")
        XCTAssertEqual(movedSnake.last!.1, 50, "Must be 50 of (51,50).")
    }
    
    func testMove(){
        let testSnake = Snake(maxX: 10, maxY: 10, diretion: .SnakeFacingLeft, bodyLength: 3)
//        testSnake.increaseLength()
        testSnake.move()
        var movedSnake = testSnake.body
        XCTAssertEqual(movedSnake.first!.0, 6, "Must be 6 of (6,5).")
        XCTAssertEqual(movedSnake.first!.1, 5, "Must be 5 of (6,5).")
        XCTAssertEqual(movedSnake.last!.0, 4, "Must be 4 of (4,5).")
        XCTAssertEqual(movedSnake.last!.1, 5, "Must be 5 of (4,5).")
        testSnake.move()
        testSnake.move()
        testSnake.changeDirection(to: .SnakeFacingDown)
        testSnake.move()
        movedSnake = testSnake.body
        XCTAssertEqual(movedSnake.first!.0, 3, "Must be 3 of (3,5).")
        XCTAssertEqual(movedSnake.first!.1, 5, "Must be 5 of (3,5).")
        XCTAssertEqual(movedSnake.last!.0, 2, "Must be 2 of (2,6).")
        XCTAssertEqual(movedSnake.last!.1, 6, "Must be 6 of (2,6).")
        testSnake.changeDirection(to: .SnakeFacingLeft)
        testSnake.move()
        testSnake.move()
        testSnake.move()
        movedSnake = testSnake.body
        XCTAssertEqual(movedSnake.first!.0, 1, "Must be 1 of (1,6).")
        XCTAssertEqual(movedSnake.first!.1, 6, "Must be 6 of (1,6).")
        XCTAssertEqual(movedSnake.last!.0, 10, "Must be 10 of (10,6).")
        XCTAssertEqual(movedSnake.last!.1, 6, "Must be 6 of (10,6).")
        testSnake.changeDirection(to: .SnakeFacingDown)
        testSnake.move()
        testSnake.move()
        testSnake.move()
        testSnake.move()
        testSnake.move()
        movedSnake = testSnake.body
        XCTAssertEqual(movedSnake.first!.0, 10, "Must be 10 of (10,9).")
        XCTAssertEqual(movedSnake.first!.1, 9, "Must be 9 of (10,9).")
        XCTAssertEqual(movedSnake.last!.0, 10, "Must be 10 of (10,0).")
        XCTAssertEqual(movedSnake.last!.1, 0, "Must be 0 of (10,0).")
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
        let testSnake = Snake(maxX: 100, maxY: 100, diretion: .SnakeFacingRight, bodyLength: 2)
        testSnake.move()
        testSnake.move()
        XCTAssertEqual(testSnake.isHitPoint(x: 52, y: 52), false, "Must be true means got the point.")
        testSnake.changeDirection(to: .SnakeFacingDown)
        testSnake.move()
        testSnake.move()
        XCTAssertEqual(testSnake.isHitPoint(x: 52, y: 52), true, "Must be true means got the point.")
        
    }

}
