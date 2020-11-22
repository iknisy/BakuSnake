//
//  Extensions.swift
//  BakuSnake
//
//  Created by 陳昱宏 on 2020/11/21.
//

import Foundation

func dPrint(_ item: Any..., function: String = #function) {
    #if DEBUG
    print("\(function): \(item)")
    #endif
}

