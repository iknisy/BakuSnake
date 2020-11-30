//
//  RankingDataService.swift
//  BakuSnake
//
//  Created by 陳昱宏 on 2020/11/23.
//

import Foundation
import FirebaseDatabase

class RankingDataService {
//    與Firebase連線用的Model
//    singleton
    static let dataService = RankingDataService()
    private init(){
        
    }
    
//    負責連線到DB根目錄的Reference
    private var _BASE_REF = FirebaseDatabase.Database.database().reference()
//    負責連線到Results目錄的Reference
    private var _RESULTS_REF = FirebaseDatabase.Database.database().reference(withPath: "results")
    
    var BASE_REF: DatabaseReference {
        return _BASE_REF
    }
    var RESULTS_REF: DatabaseReference {
        return _RESULTS_REF
    }
    
}
