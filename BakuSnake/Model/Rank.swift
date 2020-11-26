//
//  Ranking.swift
//  BakuSnake
//
//  Created by 陳昱宏 on 2020/11/22.
//

import Foundation

class Rank{
    private(set) var rank: Int
    private(set) var name: String
    private(set) var score: Int
    
    init(rank: Int, name: String, score: Int) {
        self.rank = rank
        self.name = name
        self.score = score
    }
    
    func rankDown(){
        rank += 1
    }
}
