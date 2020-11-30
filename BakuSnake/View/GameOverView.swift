//
//  GameOverView.swift
//  BakuSnake
//
//  Created by 陳昱宏 on 2020/11/22.
//

import SwiftUI

struct GameOverView: View {
//    GameView中控制dismiss用的
    @Binding var gameOverFlag: Bool
//    控制是否跳至上一頁的
    @Binding var restartFlag: Bool
    @State private var name: String = ""
    private let rankings = RankingViewModel()
    private let score: Int
    
    init(score: Int, gameOverFlag: Binding<Bool>, restartFlag: Binding<Bool>) {
        self.score = score
        self._gameOverFlag = gameOverFlag
        self._restartFlag = restartFlag
        rankings.fetchRanking(score: score)
    }
    
    var body: some View {
        VStack{
            Text("Your score: \(score)")
//            確認可以排上前10才出現輸入名字的TextField跟按鈕
            if rankings.ableUpdate {
                TextField("Your name:", text: $name)
                    .padding(.horizontal, UIScreen.main.bounds.width * 0.1)
                Button{
                    guard name != "" else {return}
                    rankings.updateRanking(name: name, score: score)
                } label: {
                    Text("Upload score")
                }
            }
            VStack{
//                從viewModel獲得排名資訊然後顯示
                Text("Best Ranking:")
                if rankings.ranking.count == 0 {
                    Text("Loading...\n")
                }else{
                    Text("NAME      SCORE")
                }
                VStack(alignment: .leading){
                    ForEach(rankings.ranking, id: \.rank){
                        Text("\($0.name)    :   \($0.score)")
                    }
                }
            }
//            回到上一頁的按鈕
            Button{
                gameOverFlag = false
            } label: {
                Text("Restart").bold()
            }
        }
        .onDisappear{
//            回到上一頁就回到最初畫面
            restartFlag = !gameOverFlag
        }
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView(score: 10, gameOverFlag: .constant(true), restartFlag: .constant(false))
    }
}
