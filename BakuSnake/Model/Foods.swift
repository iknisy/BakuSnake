//
//  Foods.swift
//  BakuSnake
//
//  Created by 陳昱宏 on 2020/11/7.
//

import Foundation

class Foods {
    private(set) var x: Int
    private(set) var y: Int
    private(set) var real: Bool
    
    init(maxX: Int, maxY: Int, isReal: Bool = true){
        real = isReal
        x = Int.random(in: 1..<maxX)
        y = Int.random(in: 1..<maxY)
    }
    
//    回傳此物件座標ＸＹ
//    func getPoint() -> (Int, Int){
//        return (x, y)
//    }
//    回傳此物件是否為真
//    func isReal() -> Bool{
//        return real
//    }
}
