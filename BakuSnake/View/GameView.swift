//
//  GameView.swift
//  BakuSnake
//
//  Created by 陳昱宏 on 2020/11/12.
//

import SwiftUI

struct GameView: View {
    @Binding var level: Int
    var body: some View {
        Text("Level: \(level).")
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(level: .constant(1))
    }
}
