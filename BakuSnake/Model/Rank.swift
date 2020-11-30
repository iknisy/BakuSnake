//
//  Ranking.swift
//  BakuSnake
//
//  Created by 陳昱宏 on 2020/11/22.
//

import Foundation

class Rank{
//    排名
    private(set) var rank: Int
//    名字
    private(set) var name: String
//    分數
    private(set) var score: Int
    
    init(rank: Int, name: String, score: Int) {
        self.rank = rank
        self.name = name
        self.score = score
    }
    
    func rankDown(){
//        排名下滑
        rank += 1
    }
}
