//
//  GameViewModel.swift
//  BakuSnake
//
//  Created by 陳昱宏 on 2020/11/15.
//

import Foundation

class GameViewModel {
    let gameSnake: Snake
    private(set) var gameFoods = [Foods]()
    private(set) var level: Int
    private(set) var gameoverFlag = false
    private(set) var multiFoodsFlag = false
    private(set) var warFogFlag = false
    private(set) var warFogLayer = 0
    private let maxX: Int
    private let maxY: Int
    private(set) var score = 0 /*{
        didSet{
            //分數的上升使難度上升
        }
    }*/
    
    init(maxX: Int, maxY: Int, level: Int) {
        self.maxX = maxX
        self.maxY = maxY
        self.level = level
        if level == 2 {
            multiFoodsFlag = true
        }
        if level == 3 {
            warFogFlag = true
            warFogLayer = 33
        }
        gameSnake = Snake(maxX: maxX, maxY: maxY)
        renewFoods()
    }
    
    func renewFoods(){
        gameFoods.removeAll()
        var realFood = Foods(maxX: maxX, maxY: maxY)
        while gameSnake.isInBody(x: realFood.x, y: realFood.y) {
            realFood = Foods(maxX: maxX, maxY: maxY)
        }
        gameFoods.append(realFood)
        if multiFoodsFlag {
            let fakeFood = Foods(maxX: maxX, maxY: maxY, isReal: false)
            gameFoods.append(fakeFood)
        }
    }
    
    func snakeMove(){
        gameSnake.move()
        if gameSnake.isHitBody() {
            gameoverFlag = true
        }
        for food in gameFoods {
            guard food.real else {continue}
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
    func hitFood(){
        gameSnake.increaseLength()
        score += 1
        renewFoods()
    }
    
    func getSnakeBody() -> [(Int, Int)] {
        var fullSnakeBody = [(Int, Int)]()
        for i in 0..<gameSnake.body.count-1 {
            if gameSnake.body[i].1 - gameSnake.body[i+1].1 == 0 {
                switch gameSnake.bodyFacing[i] {
                case .SnakeFacingLeft:
                    if gameSnake.body[i].0 < gameSnake.body[i+1].0 {
                        for j in (0...gameSnake.body[i].0).reversed() {
                            fullSnakeBody.append((j, gameSnake.body[i].1))
                        }
                        fullSnakeBody.append((-1, -1))
                        for j in stride(from: maxX, to: gameSnake.body[i+1].0, by: -1) {
                            fullSnakeBody.append((j, gameSnake.body[i].1))
                        }
                    }else{
                        for j in stride(from: gameSnake.body[i].0, to: gameSnake.body[i+1].0, by: -1) {
                            fullSnakeBody.append((j, gameSnake.body[i].1))
                        }
                    }
                case .SnakeFacingRight:
                    if gameSnake.body[i].0 > gameSnake.body[i+1].0 {
                        for j in gameSnake.body[i].0...maxX {
                            fullSnakeBody.append((j, gameSnake.body[i].1))
                        }
                        fullSnakeBody.append((-1, -1))
                        for j in 0..<gameSnake.body[i+1].0 {
                            fullSnakeBody.append((j, gameSnake.body[i].1))
                        }
                    }else{
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
