//
//  BakuSnakeApp.swift
//  BakuSnake
//
//  Created by 陳昱宏 on 2020/10/31.
//

import SwiftUI
import Firebase

@main
struct BakuSnakeApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
