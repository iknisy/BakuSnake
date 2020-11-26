//
//  RankingDataService.swift
//  BakuSnake
//
//  Created by 陳昱宏 on 2020/11/23.
//

import Foundation
import FirebaseDatabase

class RankingDataService {
    static let dataService = RankingDataService()
    
    private var _BASE_REF = FirebaseDatabase.Database.database().reference()
    private var _RESULTS_REF = FirebaseDatabase.Database.database().reference(withPath: "results")
    
    var BASE_REF: DatabaseReference {
        return _BASE_REF
    }
    var RESULTS_REF: DatabaseReference {
        return _RESULTS_REF
    }
    
}
