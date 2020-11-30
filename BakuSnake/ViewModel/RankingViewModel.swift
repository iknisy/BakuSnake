//
//  RankingViewModel.swift
//  BakuSnake
//
//  Created by 陳昱宏 on 2020/11/22.
//

import Foundation
import FirebaseDatabase

class RankingViewModel {
//    負責連至Firebase獲得排名資訊
    private(set) var ranking = [Rank]()
//    表示是否能排上前10
    private(set) var ableUpdate = false
    
    func fetchRanking(score: Int) {
//        獲得排名資訊
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
//        將分數更新至Firebase
        guard ableUpdate else {return}
//        代表是否已將最新分數insert
        var insertFlag = false
        for i in 0...9 {
//            若是已insert分數則直接將後面的排行往下推一名
            if insertFlag {
                ranking[i].rankDown()
                updateToDB(index: "\(i+1)", name: name, score: score)
            }else{
//                找到可以insert分數的地方後將原排名往下推
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
    private func updateToDB(index: String, name: String, score: Int) {
//        連線至Firebase更新排名
        RankingDataService.dataService.RESULTS_REF.setValue(name, forKeyPath: "\(index)/name")
        RankingDataService.dataService.RESULTS_REF.setValue(score, forKeyPath: "\(index)/score")
    }
}
