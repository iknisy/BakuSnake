//
//  RankingViewModel.swift
//  BakuSnake
//
//  Created by 陳昱宏 on 2020/11/22.
//

import Foundation
import FirebaseDatabase

class RankingViewModel {
    private(set) var ranking = [Rank]()
    private(set) var ableUpdate = false
    
    func fetchRanking(score: Int) {
        RankingDataService.dataService.RESULTS_REF.observeSingleEvent(of: .value) {[weak self] snapshot in
            guard let objects = snapshot.children.allObjects as? [DataSnapshot] else {return}
            guard let self = self else {return}
            self.ranking.removeAll()
            for i in 0..<objects.count {
                if let value = objects[i].value as? [String: Any], let name = value["name"] as? String, let score = value["score"] as? Int {
                    let rank = Rank(rank: i+1, name: name, score: score)
                    self.ranking.append(rank)
                }
            }
            if let last = self.ranking.last, score > last.score {
                self.ableUpdate = true
            }
        }
    }
    
    func updateRanking(name: String, score: Int){
        guard ableUpdate else {return}
        var insertFlag = false
        for i in 0...9 {
            if insertFlag {
                ranking[i].rankDown()
                updateToDB(index: "\(i+1)", name: name, score: score)
            }else{
                if score > ranking[i].score {
                    let rank = Rank(rank: i+1, name: name, score: score)
                    ranking.insert(rank, at: i)
                    updateToDB(index: "\(i+1)", name: name, score: score)
                    insertFlag = true
                }
            }
        }
        ranking.removeLast()
        ableUpdate = false
    }
    
    func updateToDB(index: String, name: String, score: Int) {
        RankingDataService.dataService.RESULTS_REF.setValue(name, forKeyPath: "\(index)/name")
        RankingDataService.dataService.RESULTS_REF.setValue(score, forKeyPath: "\(index)/score")
    }
}
