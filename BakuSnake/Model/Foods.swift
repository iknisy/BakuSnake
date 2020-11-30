//
//  Foods.swift
//  BakuSnake
//
//  Created by 陳昱宏 on 2020/11/7.
//

import Foundation

class Foods {
//    存放xy座標點
    private(set) var x: Int
    private(set) var y: Int
//    表示這個點是否是真的
    private(set) var real: Bool
    
    init(maxX: Int, maxY: Int, isReal: Bool = true){
        real = isReal
        x = Int.random(in: 1..<maxX)
        y = Int.random(in: 1..<maxY)
    }
    
}
