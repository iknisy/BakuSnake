//
//  Snake.swift
//  BakuSnake
//
//  Created by 陳昱宏 on 2020/11/6.
//

import Foundation

class Snake {
    private(set) var body: [(Int, Int)]
    private(set) var bodyFacing: [SnakeDirection]
    private(set) var facing: SnakeDirection
    private(set) var length: UInt
    private var increaseFlag = false
    private let maxX: Int
    private let maxY: Int
    
    init(maxX: Int, maxY: Int, diretion: SnakeDirection = .SnakeFacingRight, bodyLength: UInt = 2) {
        facing = diretion
        length = bodyLength
        self.maxX = maxX
        self.maxY = maxY
        switch diretion {
        case .SnakeFacingRight:
            body = [(maxX/2-Int(bodyLength-1),maxY/2)]
        case .SnakeFacingLeft:
            body = [(maxX/2+Int(bodyLength-1),maxY/2)]
        case .SnakeFacingUp:
            body = [(maxX/2,maxY/2+Int(bodyLength-1))]
        case .SnakeFacingDown:
            body = [(maxX/2,maxY/2-Int(bodyLength-1))]
        }
        body.append((maxX/2, maxY/2))
        bodyFacing = [facing]
    }
//    func getBody() -> [(Int, Int)] {
//        return body
//    }
//    func getDirection() -> SnakeDirection {
//        return facing
//    }
//    func getLength() -> UInt {
//        return length
//    }
    
    func changeDirection(to newDirection: SnakeDirection) {
        let diff = facing.rawValue - newDirection.rawValue
        if abs(diff) == 2 || diff == 0 {return}
        facing = newDirection
        bodyFacing.append(facing)
        body.append(body.last!)
    }
    func increaseLength(){
        if increaseFlag {return}
        length += 1
        increaseFlag = true
    }
    func move(){
//        append head
        let head = body.popLast()!
        switch facing {
        case .SnakeFacingRight:
            if head.0 == maxX {
                body.append((0, head.1))
            }else{
                body.append((head.0+1, head.1))
            }
        case .SnakeFacingLeft:
            if head.0 == 0 {
                body.append((maxX, head.1))
            }else{
                body.append((head.0-1, head.1))
            }
        case .SnakeFacingDown:
            if head.1 == maxY {
                body.append((head.0, 0))
            }else{
                body.append((head.0, head.1+1))
            }
        case .SnakeFacingUp:
            if head.1 == 0 {
                body.append((head.0, maxY))
            }else{
                body.append((head.0, head.1-1))
            }
        }
        
//        Pop tail
        if increaseFlag {
            increaseFlag = false
            return
        }
        switch bodyFacing[0] {
        case .SnakeFacingUp:
            if body[0].1 == 0 {
                body[0].1 = maxY
            }else{
                body[0].1 -= 1
            }
        case .SnakeFacingDown:
            if body[0].1 == maxY {
                body[0].1 = 0
            }else{
                body[0].1 += 1
            }
        case .SnakeFacingLeft:
            if body[0].0 == 0 {
                body[0].0 = maxX
            }else{
                body[0].0 -= 1
            }
        case .SnakeFacingRight:
            if body[0].0 == maxX {
                body[0].0 = 0
            }else{
                body[0].0 += 1
            }
        }
        if body[0] == body[1] {
            body.removeFirst()
            bodyFacing.removeFirst()
        }
    }
    
    func isHitBody() -> Bool {
        return isInBody(x: body.last!.0, y: body.last!.1)
    }
    func isHitPoint(x: Int, y: Int) -> Bool {
        if body.last!.0 == x && body.last!.1 == y {
            return true
        }
        return false
    }
    func isInBody(x: Int, y: Int) -> Bool {
        for i in 1..<body.count-1 {
            let pastPoint = body[i-1]
            let currPoint = body[i]
            if pastPoint.0 - currPoint.0 == 0 {
                if x != pastPoint.0 {continue}
                switch bodyFacing[i-1] {
                case .SnakeFacingUp:
                    if pastPoint.1 < currPoint.1 {
                        if passBody(from: currPoint.1, through: maxY, target: y) || passBody(from: 0, through: pastPoint.1, target: y) {return true}
                    }else{
                        if passBody(from: currPoint.1, through: pastPoint.1, target: y) {return true}
                    }
                case .SnakeFacingDown:
                    if pastPoint.1 > currPoint.1 {
                        if passBody(from: pastPoint.1, through: maxY, target: y) || passBody(from: 0, through: currPoint.1, target: y) {return true}
                    }else{
                        if passBody(from: pastPoint.1, through: currPoint.1, target: y) {return true}
                    }
                default:
                    break
                }
            }else{
                if y != pastPoint.1 {continue}
                switch bodyFacing[i-1] {
                case .SnakeFacingLeft:
                    if pastPoint.0 < currPoint.0 {
                        if passBody(from: currPoint.0, through: maxX, target: x) || passBody(from: 0, through: pastPoint.0, target: x) {return true}
                    }else{
                        if passBody(from: currPoint.0, through: pastPoint.0, target: x) {return true}
                    }
                case .SnakeFacingRight:
                    if pastPoint.0 > currPoint.0 {
                        if passBody(from: pastPoint.0, through: maxX, target: x) || passBody(from: 0, through: currPoint.0, target: x) {return true}
                    }else{
                        if passBody(from: pastPoint.0, through: currPoint.0, target: x) {return true}
                    }
                default:
                    break
                }
            }
        }
        return false
    }
    private func passBody(from: Int, through: Int, target: Int) -> Bool {
        for i in from...through {
            if target == i {
                return true
            }
        }
        return false
    }
    
}

enum SnakeDirection: Int {
    case SnakeFacingUp = 0, SnakeFacingRight, SnakeFacingDown, SnakeFacingLeft
}
