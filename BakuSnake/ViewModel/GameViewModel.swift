//
//  GameViewModel.swift
//  BakuSnake
//
//  Created by 陳昱宏 on 2020/11/15.
//

import Foundation

class GameViewModel {
//    負責GameView的ViewModel
    let gameSnake: Snake
    private(set) var gameFoods = [Foods]()
    private(set) var level: Int
//    代表是否遊戲結束
    private(set) var gameoverFlag = false
//    同一畫面中食物的數量
    private(set) var foodNumber = 1
//    戰爭迷霧的層數，單位為百分比
    private(set) var warFogLayer = 0
//    存放畫面最大座標
    private let maxX: Int
    private let maxY: Int
    private(set) var score = 0 {
        didSet{
            //分數的上升使難度上升
            if score % 10 == 0 && score > 0 {
                upgrade()
            }
        }
    }
    private func upgrade(){
//        提升難度
//        依據遊戲等級決定如何提升難度
        switch level {
        case 2:
//            食物最多10個，每次提昇都加一
            guard foodNumber < 10 else {return}
            foodNumber += 1
        case 3:
//            層數最多90，每次提昇都加10
            guard warFogLayer < 90 else {return}
            warFogLayer += 10
        default:
            return
        }
    }
    
    init(maxX: Int, maxY: Int, level: Int) {
        self.maxX = maxX
        self.maxY = maxY
        self.level = level
        if level == 2 {
//            初始設定兩個食物
            foodNumber = 2
        }
        if level == 3 {
//            初始設定10％的戰爭迷霧
            warFogLayer = 10
        }
        gameSnake = Snake(maxX: maxX, maxY: maxY)
        renewFoods()
    }
    
    private func renewFoods(){
        gameFoods.removeAll()
//        生成新的食物
        var realFood = Foods(maxX: maxX, maxY: maxY)
//        若新的食物與蛇的身體重疊就重新生成一個
        while gameSnake.isInBody(x: realFood.x, y: realFood.y) {
            realFood = Foods(maxX: maxX, maxY: maxY)
        }
        gameFoods.append(realFood)
//        guard foodNumber > 1 else {return}
//        生成食物的幻影
        for _ in 1..<foodNumber {
            let fakeFood = Foods(maxX: maxX, maxY: maxY, isReal: false)
            gameFoods.append(fakeFood)
        }
    }
    
    func snakeMove(){
//        蛇前進一格
        gameSnake.move()
//        若撞到身體則遊戲結束
        if gameSnake.isHitBody() {
            gameoverFlag = true
        }
//        檢查蛇是否吃到食物
        for food in gameFoods {
//            確保只檢查真的食物
            guard food.real else {continue}
//            依據蛇的前進方向，檢查是否進入食物周圍5單位，是的話就算吃到食物
            switch gameSnake.facing {
            case .SnakeFacingUp, .SnakeFacingDown:
                for i in (food.x-5)...(food.x+5) {
                    if gameSnake.isHitPoint(x: i, y: food.y) {hitFood()}
                }
            case .SnakeFacingLeft, .SnakeFacingRight:
                for i in (food.y-5)...(food.y+5) {
                    if gameSnake.isHitPoint(x: food.x, y: i) {hitFood()}
                }
            }
        }
    }
    private func hitFood(){
//        吃到食物後的動作
        gameSnake.increaseLength()
        score += 1
        renewFoods()
    }
    
    func getSnakeBody() -> [(Int, Int)] {
//        計算身體的每個座標點，以便View繪製
        var fullSnakeBody = [(Int, Int)]()
        for i in 0..<gameSnake.body.count-1 {
//            取每一段身體
            if gameSnake.body[i].1 - gameSnake.body[i+1].1 == 0 {
                switch gameSnake.bodyFacing[i] {
                case .SnakeFacingLeft:
                    if gameSnake.body[i].0 < gameSnake.body[i+1].0 {
//                        發生穿牆
                        for j in (0...gameSnake.body[i].0).reversed() {
                            fullSnakeBody.append((j, gameSnake.body[i].1))
                        }
//                        穿牆的地方以(-1,-1)以在繪製時辨識
                        fullSnakeBody.append((-1, -1))
                        for j in stride(from: maxX, to: gameSnake.body[i+1].0, by: -1) {
                            fullSnakeBody.append((j, gameSnake.body[i].1))
                        }
                    }else{
//                        未發生穿牆
                        for j in stride(from: gameSnake.body[i].0, to: gameSnake.body[i+1].0, by: -1) {
                            fullSnakeBody.append((j, gameSnake.body[i].1))
                        }
                    }
                case .SnakeFacingRight:
                    if gameSnake.body[i].0 > gameSnake.body[i+1].0 {
//                        發生穿牆
                        for j in gameSnake.body[i].0...maxX {
                            fullSnakeBody.append((j, gameSnake.body[i].1))
                        }
//                        穿牆的地方以(-1,-1)以在繪製時辨識
                        fullSnakeBody.append((-1, -1))
                        for j in 0..<gameSnake.body[i+1].0 {
                            fullSnakeBody.append((j, gameSnake.body[i].1))
                        }
                    }else{
//                        未發生穿牆
                        for j in gameSnake.body[i].0...gameSnake.body[i+1].0 {
                            fullSnakeBody.append((j, gameSnake.body[i].1))
                        }
                    }
                default:
                    dPrint("Error!getSnakeBody1")
                }
            }else{
                switch gameSnake.bodyFacing[i] {
                case .SnakeFacingUp:
                    if gameSnake.body[i].1 < gameSnake.body[i+1].1 {
                        for j in (0...gameSnake.body[i].1).reversed() {
                            fullSnakeBody.append((gameSnake.body[i].0, j))
                        }
//                        穿牆的地方以(-1,-1)以在繪製時辨識
                        fullSnakeBody.append((-1, -1))
                        for j in stride(from: maxY, to: gameSnake.body[i+1].1, by: -1) {
                            fullSnakeBody.append((gameSnake.body[i].0, j))
                        }
                    }else{
                        for j in stride(from: gameSnake.body[i].1, to: gameSnake.body[i+1].1, by: -1) {
                            fullSnakeBody.append((gameSnake.body[i].0, j))
                        }
                    }
                case .SnakeFacingDown:
                    if gameSnake.body[i].1 > gameSnake.body[i+1].1 {
                        for j in gameSnake.body[i].1...maxY {
                            fullSnakeBody.append((gameSnake.body[i].0, j))
                        }
//                        穿牆的地方以(-1,-1)以在繪製時辨識
                        fullSnakeBody.append((-1, -1))
                        for j in 0..<gameSnake.body[i+1].1 {
                            fullSnakeBody.append((gameSnake.body[i].0, j))
                        }
                    }else{
                        for j in gameSnake.body[i].1..<gameSnake.body[i+1].1 {
                            fullSnakeBody.append((gameSnake.body[i].0, j))
                        }
                    }
                default:
                    dPrint("Error!getSnakeBody2")
                }
            }
        }
        fullSnakeBody.append(gameSnake.body.last!)
        return fullSnakeBody
    }
}
