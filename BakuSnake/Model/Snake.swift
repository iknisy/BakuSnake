//
//  Snake.swift
//  BakuSnake
//
//  Created by 陳昱宏 on 2020/11/6.
//

import Foundation

class Snake: NSObject {
    private var body: [(Int, Int)]
    private var facing: SnakeDirection
    private var length: UInt
    private var increaseFlag = false
    
    init(maxX: Int, maxY: Int, diretion: SnakeDirection = .SnakeFacingRight, bodyLength: UInt = 2) {
        facing = diretion
        length = bodyLength
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
    }
    func getBody() -> [(Int, Int)] {
        return body
    }
    func getDirection() -> SnakeDirection {
        return facing
    }
    func getLength() -> UInt {
        return length
    }
    
    func changeDirection(to newDirection: SnakeDirection) {
        let diff = facing.rawValue - newDirection.rawValue
            if abs(diff) == 2 || diff == 0 {return}
            facing = newDirection
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
            body.append((head.0+1, head.1))
        case .SnakeFacingLeft:
            body.append((head.0-1, head.1))
        case .SnakeFacingDown:
            body.append((head.0, head.1+1))
        case .SnakeFacingUp:
            body.append((head.0, head.1-1))
        }
        
//        Pop tail
        if increaseFlag {
            increaseFlag = false
            return
        }
        let diffX = body[0].0 - body[1].0
        let diffY = body[0].1 - body[1].1
        switch diffX.signum() {
        case 1:
            body[0].0 -= 1
        case -1:
            body[0].0 += 1
        case 0:
            if diffY.signum() == 1 {
                body[0].1 -= 1
            }else{
                body[0].1 += 1
            }
        default:
            break
        }
        if body[0] == body[1] {
            body.removeFirst()
        }
    }
    
    func isHitBody() -> Bool {
//        if body.count <= 2 {return false}
        for i in 1..<body.count-1 {
            let pastPoint = body[i-1]
            let currPoint = body[i]
            if pastPoint.0 - currPoint.0 == 0 {
                
                for j in stride(from: pastPoint.1, through: currPoint.1, by: 1) {
                    if body.last! == (pastPoint.0, j) {
                        return true
                    }
                }
            }else{
                for j in stride(from: pastPoint.0, through: currPoint.0, by: 1) {
                    if body.last! == (j, pastPoint.1) {
                        return true
                    }
                }
            }
        }
        return false
    }
    func isHitPoint(x: Int, y: Int) -> Bool {
        if body.last!.0 == x && body.last!.1 == y {
            return true
        }
        return false
    }
    
}

enum SnakeDirection: Int {
    case SnakeFacingUp = 0, SnakeFacingRight, SnakeFacingDown, SnakeFacingLeft
}
