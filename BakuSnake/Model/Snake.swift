//
//  Snake.swift
//  BakuSnake
//
//  Created by 陳昱宏 on 2020/11/6.
//

import Foundation

class Snake {
//    存放身體轉折點的座標，array的last是頭、first是尾巴
    private(set) var body: [(Int, Int)]
//    存放每一段身體轉折的前進方向
    private(set) var bodyFacing: [SnakeDirection]
//    目前的前進方向
    private(set) var facing: SnakeDirection
//    目前的身體長度
    private(set) var length: UInt
//    表示下一步是否延長身體
    private var increaseFlag = false
//    存放畫面最大座標
    private let maxX: Int
    private let maxY: Int
    
    init(maxX: Int, maxY: Int, diretion: SnakeDirection = .SnakeFacingRight, bodyLength: UInt = 2) {
        facing = diretion
        length = bodyLength
        self.maxX = maxX
        self.maxY = maxY
//        根據前進方向決定尾巴在哪裡
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
//        加入蛇的頭及身體前進方向
        body.append((maxX/2, maxY/2))
        bodyFacing = [facing]
    }
    
    func changeDirection(to newDirection: SnakeDirection) {
//        改變前進方向
        let diff = facing.rawValue - newDirection.rawValue
//        不能直接往反方向前進，也不能是原本的方向
        if abs(diff) == 2 || diff == 0 {return}
//        改變現在的前進方向
        facing = newDirection
//        存放身體的前進方向
        bodyFacing.append(facing)
//        加入轉折點
        body.append(body.last!)
    }
    func increaseLength(){
//        延長身體
//        一次只能延長一格，不接受延長後再延長
        if increaseFlag {return}
        length += 1
        increaseFlag = true
    }
    func move(){
//        前進一格
//        append head
//        將頭所在的座標pop出來修改座標再append
        let head = body.popLast()!
//        依照目前前進方向決定下一格的座標
        switch facing {
        case .SnakeFacingRight:
//            穿牆後從另一邊出現
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
//        若要延長身體就不修改尾巴的座標
        if increaseFlag {
            increaseFlag = false
            return
        }
//        依照最後一段身體的前進方向決定下一格座標
        switch bodyFacing[0] {
        case .SnakeFacingUp:
//            穿牆後從另一邊出現
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
//        尾巴若是轉折點就移除此段身體
        if body[0] == body[1] {
            body.removeFirst()
            bodyFacing.removeFirst()
        }
    }
    
    func isHitBody() -> Bool {
//        檢查頭是否撞到身體
        return isInBody(x: body.last!.0, y: body.last!.1)
    }
    func isHitPoint(x: Int, y: Int) -> Bool {
//        檢查頭是否碰到某個點
        if body.last!.0 == x && body.last!.1 == y {
            return true
        }
        return false
    }
    func isInBody(x: Int, y: Int) -> Bool {
//        檢查某個點是否在身體裡
        for i in 1..<body.count-1 {
//            從尾巴開始取每一段身體做檢查
            let pastPoint = body[i-1]
            let currPoint = body[i]
//            先確認身體垂直或水平
            if pastPoint.0 == currPoint.0 {
//                若此座標點不跟身體在同一Ｘ線上就換下一段
                if x != pastPoint.0 {continue}
//                依照此段身體的方向而做不同處理
                switch bodyFacing[i-1] {
                case .SnakeFacingUp:
//                    依照此段身體是否有穿牆而做不同的處理
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
//                若此座標點不跟身體在同一Ｙ線上就換下一段
                if y != pastPoint.1 {continue}
//                依照此段身體的方向而做不同處理
                switch bodyFacing[i-1] {
                case .SnakeFacingLeft:
//                    依照此段身體是否有穿牆而做不同的處理
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
//        檢查每個點是否有重合的for loop
        for i in from...through {
            if target == i {
                return true
            }
        }
        return false
    }
    
}

enum SnakeDirection: Int {
//    代表蛇的行進方向
    case SnakeFacingUp = 0, SnakeFacingRight, SnakeFacingDown, SnakeFacingLeft
}
